import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/forts_museum.dart';

class adminFortsMuseum extends StatefulWidget {
  const adminFortsMuseum({super.key, required String locationType});

  @override
  State<adminFortsMuseum> createState() => _FortsMuseumState();
}

class _FortsMuseumState extends State<adminFortsMuseum> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forts and Museums List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('FortsMuseum')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Forts and Museums found'));
          }

          var fortsMuseum = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: fortsMuseum.length,
            itemBuilder: (context, index) {
              var fortMuseum = fortsMuseum[index].data() as Map<String, dynamic>;
              String fortMuseumId = fortsMuseum[index].id;  // Get the document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Fort and Museum name
                        Text(
                          fortMuseum['name'] ?? 'No name',
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
                            _showDeleteConfirmationDialog(context, fortMuseumId);
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
          // Navigate to the AddFortsMuseumScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FortsMuseumDetails(locationType: 'FortsMuseum'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a fort and museum
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String fortMuseumId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Forts and Museum'),
          content: const Text('Are you sure you want to delete this fort and museum?'),
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
                // Delete the fort and museum document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('FortsMuseum')
                    .doc(fortMuseumId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forts and Museum deleted successfully!')),
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
