import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/userfirebaseFavourites.dart';

class Temples extends StatefulWidget {
  const Temples({super.key});

  @override
  State<Temples> createState() => _TemplesState();
}

class _TemplesState extends State<Temples> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, bool> favoriteStatus = {};
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temples List'),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
           colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Places')
              .doc('Locations')
              .collection('Temples')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Temples found'));
            }

            var temples = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: temples.length,
              itemBuilder: (context, index) {
                var temple = temples[index].data() as Map<String, dynamic>;
                String templeId = temples[index].id;

                if (!favoriteStatus.containsKey(templeId)) {
                  favoriteStatus[templeId] = false;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TempleDetailsScreen(
                              temple: temple,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                temple['name'] ?? 'No name',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Black text
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  favoriteStatus[templeId] =
                                      !favoriteStatus[templeId]!;
                                });

                                try {
                                  await _favoriteService.updateFavoriteStatus(
                                    templeId,
                                    temple,
                                    favoriteStatus[templeId]!,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Failed to update favorite: $e'),
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                favoriteStatus[templeId]!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favoriteStatus[templeId]!
                                    ? Colors.red
                                    : Colors.black,
                              ),
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
        title: Text(temple['name'] ?? 'Temple Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temple['name'] ?? 'No name',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Black text for title
                  ),
                ),
                const SizedBox(height: 16),

                // Description of the temple
                Text(
                  temple['description'] ?? 'No description',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 16),

                // Seasonal Time Section
                Text(
                  'Seasonal Time: ${temple['seasonalTime'] ?? 'Not available'}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 8),

                // Opening and Closing Time Section
                Text(
                  'Opening Time: ${temple['openingTime'] ?? 'Not available'}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Closing Time: ${temple['closingTime'] ?? 'Not available'}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 16),

                // Image of the temple (if available)
                temple['imageUrl'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          temple['imageUrl'],
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
                          Icons.temple_buddhist,
                          size: 50,
                          color: Colors.blueGrey,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
