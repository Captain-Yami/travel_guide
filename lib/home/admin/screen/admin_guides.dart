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
  void navigateToGuideDetails(Map<String, dynamic> guide) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuideDetailsPage(guide: guide),
      ),
    );
  }

  // Delete Guide from Firestore
  Future<void> deleteGuide(String guideId) async {
    try {
      await _firestore.collection('Guide').doc(guideId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guide deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete guide')));
    }
  }

  // Show confirmation dialog before deleting
  void showDeleteConfirmationDialog(String guideId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this guide?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteGuide(guideId); // Delete guide if confirmed
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
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
                    onTap: () => navigateToGuideDetails(guide),
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
                            // Delete Icon
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  showDeleteConfirmationDialog(guideId),
                            ),
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



// Guide details page

class GuideDetailsPage extends StatelessWidget {
  final Map<String, dynamic> guide;

  const GuideDetailsPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${guide['name']} Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Display the guide's name in a tile
              _buildTile('Name', guide['name'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Email in a tile
              _buildTile('Email', guide['guideemail'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Phone in a tile
              _buildTile('Phone', guide['phone number'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display License Number in a tile
              _buildTile('License Number', guide['License'] ?? 'Not Available'),
              const SizedBox(height: 20),
              // Display the guide's profile image or placeholder icon
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
    );
  }

  // Helper method to create a tile for guide details
  Widget _buildTile(String title, String value) {
    return Card(
      color: const Color.fromARGB(255, 39, 39, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
