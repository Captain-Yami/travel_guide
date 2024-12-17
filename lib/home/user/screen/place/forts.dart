import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';
import '../../service/favorite_service.dart'; // Import the FavoriteService class

class FortsAndMuseums extends StatefulWidget {
  const FortsAndMuseums({super.key});

  @override
  State<FortsAndMuseums> createState() => _FortsAndMuseumsState();
}

class _FortsAndMuseumsState extends State<FortsAndMuseums> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A Map to store favorite status for each fort and museum
  final Map<String, bool> favoriteStatus = {};
  
  // Create an instance of FavoriteService
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forts and Museums List'), // Changed title
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('FortsAndMuseums') // Changed collection name to 'FortsAndMuseums'
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Forts or Museums found')); // Changed text
          }

          var places = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: places.length,
            itemBuilder: (context, index) {
              var place = places[index].data() as Map<String, dynamic>;
              String placeId = places[index].id; // Unique ID for each fort or museum

              // Initialize the favorite status if not already done
              if (!favoriteStatus.containsKey(placeId)) {
                favoriteStatus[placeId] = false;
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
                    // Navigate to the FortOrMuseumDetailsScreen with place data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FortOrMuseumDetailsScreen(
                          place: place,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name with overflow handling
                      Flexible(
                        child: Text(
                          place['location_name'] ?? 'No name',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
                        ),
                      ),
                      // Favourite Icon
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            // Toggle favorite status in the UI
                            favoriteStatus[placeId] = !favoriteStatus[placeId]!;
                          });

                          try {
                            // Call the backend service to update the favorite status
                            await _favoriteService.updateFavoriteStatus(
                              placeId,
                              place,
                              favoriteStatus[placeId]!,
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
                          favoriteStatus[placeId]! ? Icons.favorite : Icons.favorite_border,
                          color: favoriteStatus[placeId]! ? Colors.red : Colors.grey,
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

class FortOrMuseumDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const FortOrMuseumDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place['location_name'] ?? 'Fort or Museum Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name of the place (fort or museum)
            Text(
              place['location_name'] ?? 'No name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 8.0), // Add some space between name and description

            // Description of the place
            Text(
              place['location_description'] ?? 'No description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(height: 16.0), // Space between description and image

            // Image of the place (if available)
            place['image_url'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      place['image_url'],
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
                      Icons.location_city, // Generic icon for fort or museum
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
