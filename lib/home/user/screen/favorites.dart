import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // Stream to fetch data from Firestore
  late Stream<DocumentSnapshot> _favoritesStream;

  @override
  void initState() {
    super.initState();
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // Create the stream to fetch the user's favorite data using UID as the document ID
    _favoritesStream = FirebaseFirestore.instance
        .collection('Favourites')
        .doc(uid) // Document ID is the user's UID
        .snapshots();
        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No favorites found.'));
          }

          var favoriteData = snapshot.data!.data() as Map<String, dynamic>;
          print(favoriteData);

          // If there are multiple items inside the document, you can retrieve them from a subcollection
          List favoriteItems = favoriteData['beaches'] ?? [];

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              var favoriteItem = favoriteItems[index] as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: favoriteItem['item_image'] != null
                      ? Image.network(
                          favoriteItem['item_image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image),
                  title: Text(favoriteItem['location_name'] ?? 'No Name'),
                  subtitle: Text(favoriteItem['location_description'] ?? 'No Description'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
