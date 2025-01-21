import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';

class TrekkingSpots extends StatefulWidget {
  const TrekkingSpots({super.key});

  @override
  State<TrekkingSpots> createState() => _TrekkingSpotsState();
}

class _TrekkingSpotsState extends State<TrekkingSpots> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A Map to store favorite status for each trekking spot
  final Map<String, bool> favoriteStatus = {};

  // Create an instance of FavoriteService
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trekking Spots List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      // Use Linear Gradient for background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ], // Three colors for gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Places')
              .doc('Locations')
              .collection(
                  'Trekking') // Changed to 'Trekking' instead of 'Temples'
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No Trekking Spots found')); // Changed text
            }

            var trekkingSpots = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: trekkingSpots.length,
              itemBuilder: (context, index) {
                var trekkingSpot =
                    trekkingSpots[index].data() as Map<String, dynamic>;
                String trekkingSpotId =
                    trekkingSpots[index].id; // Unique ID for each trekking spot

                // Initialize the favorite status if not already done
                if (!favoriteStatus.containsKey(trekkingSpotId)) {
                  favoriteStatus[trekkingSpotId] = false;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      backgroundColor:
                          Colors.green, // Green background for card
                      elevation: 6,
                      minimumSize: Size(double.infinity, 80),
                    ),
                    onPressed: () {
                      // Navigate to the TrekkingSpotDetailsScreen with trekking spot data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrekkingSpotDetailsScreen(
                            trekkingSpot: trekkingSpot,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Trekking spot name with overflow handling
                        Flexible(
                          child: Text(
                            trekkingSpot['name'] ?? 'No name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Black font color
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Handle overflow if text is too long
                          ),
                        ),
                        // Favourite Icon
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              // Toggle favorite status in the UI
                              favoriteStatus[trekkingSpotId] =
                                  !favoriteStatus[trekkingSpotId]!;
                            });

                            try {
                              // Call the backend service to update the favorite status
                              await _favoriteService.updateFavoriteStatus(
                                trekkingSpotId,
                                trekkingSpot,
                                favoriteStatus[trekkingSpotId]!,
                              );
                            } catch (e) {
                              // Handle any errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Failed to update favorite: $e'),
                                ),
                              );
                            }
                          },
                          child: Icon(
                            favoriteStatus[trekkingSpotId]!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteStatus[trekkingSpotId]!
                                ? Colors.red
                                : Colors.black,
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
      ),
    );
  }
}

class TrekkingSpotDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> trekkingSpot;

  const TrekkingSpotDetailsScreen({super.key, required this.trekkingSpot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trekkingSpot['name'] ?? 'Trekking Spot Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor:
          Color.fromARGB(255, 16, 31, 29), // Slightly lighter black

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name of the trekking spot
            Text(
              trekkingSpot['name'] ?? 'No name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(
                height: 8.0), // Add some space between name and description

            // Description of the trekking spot
            Text(
              trekkingSpot['description'] ?? 'No description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0),
            // Seasonal Time Section
            Text(
              'Seasonal Time: ${trekkingSpot['seasonalTime'] ?? 'Not available'}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0), // Space between description and image

            // Image of the trekking spot (if available)
            trekkingSpot['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      trekkingSpot['imageUrl'],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.green, // Green background for card
                    child: const Icon(
                      Icons.nature, // Icon for trekking spot
                      size: 50,
                      color: Colors.green, // Green background for card
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
