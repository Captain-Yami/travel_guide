import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Beaches extends StatefulWidget {
  const Beaches({super.key});

  @override
  State<Beaches> createState() => _BeachesState();
}

class _BeachesState extends State<Beaches> {
  // Create an instance of FirebaseFirestore
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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name of the beach
                    Text(
                      beach['location_name'] ?? 'No name',
                      style: TextStyle(
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900], // Darker text color
                      ),
                    ),
                    const SizedBox(height: 4.0), // Add space between name and description

                    // Description of the beach
                    Text(
                      beach['location_description'] ?? 'No description',
                      style: TextStyle(
                        fontSize: 16, // Increased font size
                        color: Colors.blueGrey[700], // Slightly lighter text color
                      ),
                    ),
                    const SizedBox(height: 8.0), // Add space between description and image

                    // Image (or placeholder if no image_url)
                    beach['image_url'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              beach['image_url'],
                              width: double.infinity, // Take up full width
                              height: 200, // Set a fixed height for the image
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.blueGrey[100],
                            child: const Icon(
                              Icons.beach_access,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                          ),
                    const SizedBox(height: 16.0), // Add space after the image
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


