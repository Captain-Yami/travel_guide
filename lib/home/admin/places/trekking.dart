import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/Trekking_details.dart';

class adminTrekking extends StatefulWidget {
  const adminTrekking({super.key, required String locationType});

  @override
  State<adminTrekking> createState() => _TrekkingState();
}

class _TrekkingState extends State<adminTrekking> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trekking List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('Trekking')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Trekking places found'));
          }

          var trekking = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: trekking.length,
            itemBuilder: (context, index) {
              var trek = trekking[index].data() as Map<String, dynamic>;
              String trekId = trekking[index].id;  // Get the document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Trek name
                        Text(
                          trek['name'] ?? 'No name',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        // Delete button
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            _showDeleteConfirmationDialog(context, trekId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTrekkingScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrekkingDetails(locationType: 'Trekking'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a trekking
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String trekId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Trekking Place'),
          content: const Text('Are you sure you want to delete this trekking place?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the trekking document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('Trekking')
                    .doc(trekId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trekking place deleted successfully!')),
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
