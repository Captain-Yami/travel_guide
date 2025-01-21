import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';

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
        title: const Text('Forts and Museums List'),
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
              .collection('FortsMuseum') // Collection for Forts and Museums
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Forts or Museums found'));
            }

            var places = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: places.length,
              itemBuilder: (context, index) {
                var place = places[index].data() as Map<String, dynamic>;
                String placeId =
                    places[index].id; // Unique ID for each fort or museum

                // Initialize the favorite status if not already done
                if (!favoriteStatus.containsKey(placeId)) {
                  favoriteStatus[placeId] = false;
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
                      // Navigate to the FortOrMuseumDetailsScreen with place data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FortOrMuseumDetailsScreen(
                            place:
                                place, // Passing place data including name and description
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
                            place['name'] ?? 'No name', // Display name of fort or museum
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
                              favoriteStatus[placeId] =
                                  !favoriteStatus[placeId]!;
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
                                  content:
                                      Text('Failed to update favorite: $e'),
                                ),
                              );
                            }
                          },
                          child: Icon(
                            favoriteStatus[placeId]!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteStatus[placeId]!
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

class FortOrMuseumDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const FortOrMuseumDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place['name'] ?? 'Fort or Museum Details'),
        backgroundColor: Color.fromARGB(255, 22, 40, 37),
      ),
      backgroundColor: Color.fromARGB(255, 16, 31, 29),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name of the place (fort or museum)
            Text(
              place['name'] ?? 'No name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(
                height: 8.0), // Add some space between name and description

            // Description of the place
            Text(
              place['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0), // Space between description and image
            // Opening time section
            Text(
              place['openingTime'] ?? 'No opening time available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0), // Space between opening time and closing time
            // Closing time section
            Text(
              place['closingTime'] ?? 'No closing time available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0), // Space between closing time and seasonal time
            // Seasonal time section
            Text(
              place['seasonalTime'] ?? 'No seasonal time available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green, // Green background for card
              ),
            ),
            const SizedBox(height: 16.0), // Space between seasonal time and image

            // Image of the place (if available)
            place['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      place['imageUrl'],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.green, // Green background for card
                    child: Icon(
                      Icons.location_city, // Generic icon for fort or museum
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
