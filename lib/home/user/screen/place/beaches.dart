import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';
// Import the FavoriteService class

class Beaches extends StatefulWidget {
  const Beaches({super.key});

  @override
  State<Beaches> createState() => _BeachesState();
}

class _BeachesState extends State<Beaches> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A Map to store favorite status for each beach
  final Map<String, bool> favoriteStatus = {};
  
  // Create an instance of FavoriteService
  final FavoriteService _favoriteService = FavoriteService();

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
              String beachId = beaches[index].id; // Unique ID for each beach

              // Initialize the favorite status if not already done
              if (!favoriteStatus.containsKey(beachId)) {
                favoriteStatus[beachId] = false;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    backgroundColor: Colors.white,
                    elevation: 6,
                    minimumSize: Size(double.infinity, 80),
                  ),
                  onPressed: () {
                    // Navigate to the BeachDetailsScreen with beach data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeachDetailsScreen(
                          beach: beach,
                        ),
                      ),
                    );
                  },
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
                      // Favourite Icon
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            // Toggle favorite status in the UI
                            favoriteStatus[beachId] = !favoriteStatus[beachId]!;
                          });

                          try {
                            // Call the backend service to update the favorite status
                            await _favoriteService.updateFavoriteStatus(
                              beachId,
                              beach,
                              favoriteStatus[beachId]!,
                            );
                          } catch (e) {
                            // Handle any errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update favorite: $e'),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          favoriteStatus[beachId]! ? Icons.favorite : Icons.favorite_border,
                          color: favoriteStatus[beachId]! ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BeachDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> beach;

  const BeachDetailsScreen({super.key, required this.beach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beach['name'] ?? 'Beach Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name of the beach
            Text(
              beach['name'] ?? 'No name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 8.0), // Add some space between name and description

            // Description of the beach
            Text(
              beach['description'] ?? 'No description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[700],
              ),
            ),
           
            const SizedBox(height: 16.0),

            // Seasonal Time Section
            Text(
              'Seasonal Time: ${beach['seasonalTime'] ?? 'Not available'}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 8.0),

            // Opening and Closing Time Section
            Text(
              'Opening Time: ${beach['openingTime'] ?? 'Not available'}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Closing Time: ${beach['closingTime'] ?? 'Not available'}',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),
            ),
             const SizedBox(height: 16.0), // Space between description and image

            // Image of the beach (if available)
            beach['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      beach['imageUrl'],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.blueGrey[100],
                    child: const Icon(
                      Icons.beach_access,
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
