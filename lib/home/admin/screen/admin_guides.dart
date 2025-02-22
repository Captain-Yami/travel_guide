import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminGuides extends StatefulWidget {
  const AdminGuides({super.key});

  @override
  State<AdminGuides> createState() => _AdminGuidesState();
}

class _AdminGuidesState extends State<AdminGuides> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedGender = 'All'; // Default gender filter

  // Stream to get guides data from Firestore
  Stream<QuerySnapshot> getGuideStream() {
    var guideCollection = _firestore.collection('Guide');
    if (selectedGender == 'All') {
      return guideCollection.snapshots(); // Get all guides
    } else {
      return guideCollection
          .where('gender', isEqualTo: selectedGender)
          .snapshots(); // Filter by gender
    }
  }

  // Show Gender Filter Dialog
  void showGenderFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['All', 'Male', 'Female', 'Other'].map((gender) {
              return RadioListTile<String>(
                title: Text(gender),
                value: gender,
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                    Navigator.pop(context);
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Navigate to the guide details page
  // Navigate to the guide details page
  void navigateToGuideDetails(Map<String, dynamic> guide, String guideId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuideDetailsPage(
          guide: guide,
          guideId: guideId, // Pass guideId along with guide
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin - Guides',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 29, 29),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        // Adding a linear gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ], // Three colors for the gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: getGuideStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Guides found'));
            }

            var guides = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: guides.length,
              itemBuilder: (context, index) {
                var guide = guides[index].data() as Map<String, dynamic>;
                String guideId = guides[index].id; // Get the guide ID

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => navigateToGuideDetails(guide, guideId),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.green, // Green card background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Display profile image if available or default account icon
                            guide['image'] != null && guide['image'].isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(guide['image']),
                                  )
                                : Icon(
                                    Icons
                                        .account_circle, // Account icon as fallback
                                    size: 60, // Icon size
                                    color: Colors.black, // Icon color
                                  ),
                            const SizedBox(width: 16),
                            // Display guide name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guide['name'] ?? 'No name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Font color black
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showGenderFilterDialog,
        child: const Icon(Icons.filter_list),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}

class GuideDetailsPage extends StatelessWidget {
  final Map<String, dynamic> guide;
  final String guideId;

  GuideDetailsPage({super.key, required this.guide, required this.guideId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Suspend the guide with a reason
// Suspend the guide with a reason
// Suspend the guide with a reason
  Future<void> suspendGuide(
      BuildContext context, String guideId, String reason) async {
    if (guideId.isEmpty || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guide ID or Reason is empty')),
      );
      return;
    }

    try {
      // Get the guide data from the Guide collection to fetch the email
      DocumentSnapshot guideDoc =
          await _firestore.collection('Guide').doc(guideId).get();

      if (!guideDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guide not found')),
        );
        return;
      }

      String guideEmail = guideDoc['gideemail'] ?? ''; // Fetch the guide email

      // Start a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        // Set the data in the 'suspend' collection
        await transaction.set(_firestore.collection('suspend').doc(guideId), {
          'guideemail': guideEmail, // Store guide email
          'status': true, // Guide is suspended
          'id': guideId, // Store guide ID
          'reason': FieldValue.arrayUnion([
            reason
          ]), // Add reason to the list, does not overwrite previous reasons
          'timestamp': FieldValue
              .serverTimestamp(), // Optionally, track when the suspension happened
        });

        // Update the guide's status in the 'Guide' collection
        await transaction.update(_firestore.collection('Guide').doc(guideId), {
          'status': true, // Guide is suspended
        });
      });

      // Show success dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guide suspended successfully')),
      );
    } catch (e) {
      // Handle any errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('An error occurred while suspending the guide.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

// Revoke the suspension of the guide
// Revoke the suspension of the guide
// Revoke the suspension of the guide
// Revoke the suspension of the guide
  Future<void> revokeSuspension(BuildContext context, String guideId) async {
    try {
      // Start a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        // Fetch the current suspension status from the 'suspend' collection
        DocumentSnapshot suspendDoc =
            await _firestore.collection('suspend').doc(guideId).get();

        if (suspendDoc.exists) {
          bool isSuspended = suspendDoc['status'] ?? false;

          if (isSuspended) {
            // Revoke the suspension (set status to false)
            await transaction
                .update(_firestore.collection('suspend').doc(guideId), {
              'status': false, // Revoke the suspension (set status to false)
            });

            // Update the guide status in the 'Guide' collection
            await transaction
                .update(_firestore.collection('Guide').doc(guideId), {
              'status': false, // Guide is no longer suspended
            });

            // Show success dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Suspension Revoked'),
                  content: const Text(
                      'The suspension has been successfully revoked.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            // If the guide is already not suspended, show a message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The guide is not suspended.')),
            );
          }
        } else {
          // If the suspend document doesn't exist, it means the guide is not suspended
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No suspension record found for this guide.')),
          );
        }
      });
    } catch (e) {
      // Handle any errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('An error occurred while revoking the suspension.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Show suspension dialog
  void showSuspensionDialog(BuildContext context, String guideId) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suspend Guide'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for suspending this guide:'),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration:
                    const InputDecoration(hintText: 'Enter reason here'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  suspendGuide(context, guideId, reason);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a reason.')),
                  );
                }
              },
              child: const Text('Suspend'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${guide['name'] ?? 'Unknown'} Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(12, 22, 21, 1),
              Color.fromARGB(255, 16, 31, 29),
              Color.fromARGB(255, 14, 26, 25),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTile('Name', guide['name'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Email', guide['guideemail'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Phone', guide['phone number'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('License Number', guide['License'] ?? 'Not Available'),
              const SizedBox(height: 20),
              guide['image'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        guide['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.blueGrey[100],
                      child: const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (guide['status'] == true) // Check if suspended
            FloatingActionButton(
              onPressed: () {
                if (guideId.isNotEmpty) {
                  revokeSuspension(context, guideId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Guide ID is not available')),
                  );
                }
              },
              child: Icon(Icons.undo),
              backgroundColor: Colors.green, // Green for revoking
              heroTag: null, // To prevent duplicate hero tag error
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              if (guideId.isNotEmpty) {
                showSuspensionDialog(context, guideId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guide ID is not available')),
                );
              }
            },
            child: Icon(Icons.report_problem),
            backgroundColor: Colors.red,
            heroTag: null, // To prevent duplicate hero tag error
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return Card(
      color: const Color.fromARGB(255, 39, 39, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
