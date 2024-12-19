import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/Beaches_details.dart';

class adminBeaches extends StatefulWidget {
  const adminBeaches({super.key, required String locationType});

  @override
  State<adminBeaches> createState() => _BeachesState();
}

class _BeachesState extends State<adminBeaches> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beaches List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('Beaches')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Beaches found'));
          }

          var beaches = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: beaches.length,
            itemBuilder: (context, index) {
              var beach = beaches[index].data() as Map<String, dynamic>;
              String beachId = beaches[index].id;  // Get the document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Beach name
                        Text(
                          beach['name'] ?? 'No name',
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
                            _showDeleteConfirmationDialog(context, beachId);
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
          // Navigate to the AddBeachScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BeachesDetails(locationType: 'Beaches'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a beach
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String beachId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Beach'),
          content: const Text('Are you sure you want to delete this beach?'),
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
                // Delete the beach document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('Beaches')
                    .doc(beachId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Beach deleted successfully!')),
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
