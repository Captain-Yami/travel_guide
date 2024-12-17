import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';
import '../../service/favorite_service.dart'; // Import the FavoriteService class

class Temples extends StatefulWidget {
  const Temples({super.key});

  @override
  State<Temples> createState() => _TemplesState();
}

class _TemplesState extends State<Temples> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // A Map to store favorite status for each temple
  final Map<String, bool> favoriteStatus = {};
  
  // Create an instance of FavoriteService
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temples List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('Temples') // Changed to 'Temples' instead of 'Beaches'
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Temples found')); // Changed text
          }

          var temples = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              var temple = temples[index].data() as Map<String, dynamic>;
              String templeId = temples[index].id; // Unique ID for each temple

              // Initialize the favorite status if not already done
              if (!favoriteStatus.containsKey(templeId)) {
                favoriteStatus[templeId] = false;
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
                    // Navigate to the TempleDetailsScreen with temple data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TempleDetailsScreen(
                          temple: temple,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Temple name with overflow handling
                      Flexible(
                        child: Text(
                          temple['location_name'] ?? 'No name',
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
                            favoriteStatus[templeId] = !favoriteStatus[templeId]!;
                          });

                          try {
                            // Call the backend service to update the favorite status
                            await _favoriteService.updateFavoriteStatus(
                              templeId,
                              temple,
                              favoriteStatus[templeId]!,
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
                          favoriteStatus[templeId]! ? Icons.favorite : Icons.favorite_border,
                          color: favoriteStatus[templeId]! ? Colors.red : Colors.grey,
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

class TempleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> temple;

  const TempleDetailsScreen({super.key, required this.temple});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(temple['location_name'] ?? 'Temple Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name of the temple
            Text(
              temple['location_name'] ?? 'No name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 8.0), // Add some space between name and description

            // Description of the temple
            Text(
              temple['location_description'] ?? 'No description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(height: 16.0), // Space between description and image

            // Image of the temple (if available)
            temple['image_url'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      temple['image_url'],
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
                      Icons.temple_buddhist, // Icon for temple
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
