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
      return guideCollection.where('gender', isEqualTo: selectedGender).snapshots(); // Filter by gender
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete guide')));
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
        title: const Text('Admin - Guides'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                guide['image'] ?? 'https://example.com/default-avatar.png'),
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
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                              Text(guide['gender'] ?? 'No gender'),
                            ],
                          ),
                          const Spacer(),
                          // Delete Icon
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => showDeleteConfirmationDialog(guideId),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the guide's name
            Text(
              'Name: ${guide['name']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Display more guide details
            Text(
              'Gender: ${guide['gender']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${guide['guideemail']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: ${guide['phone number']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'License Number: ${guide['License']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
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
    );
  }
}
