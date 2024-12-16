import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Function to add or remove a beach from the user's favorites
  Future<void> updateFavoriteStatus(String beachId, Map<String, dynamic> beach, bool isFavorite) async {
    if (currentUser == null) {
      throw Exception("User not authenticated.");
    }

    // Reference to the user's document in the Favourites collection
    DocumentReference userDocRef = _firestore.collection('Favourites').doc(currentUser!.uid);

    // Fetch the current favorites of the user
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    // If the user document doesn't exist, create a new one
    if (!userDocSnapshot.exists) {
      await userDocRef.set({
        'beaches': [],
      });
    }

    // Get the current list of favorite beaches
    List<dynamic> currentFavorites = (userDocSnapshot.data() as Map<String, dynamic>)['beaches'] ?? [];

    if (isFavorite) {
      // Add the beach to the user's favorites if not already added
      if (!currentFavorites.any((item) => item['beachId'] == beachId)) {
        currentFavorites.add({
          'beachId': beachId,
          'location_name': beach['location_name'],
          'location_description': beach['location_description'],
          'image_url': beach['image_url'],
        });
      }
    } else {
      // Remove the beach from the user's favorites
      currentFavorites.removeWhere((item) => item['beachId'] == beachId);
    }

    // Update the user's Favourites document in Firestore
    await userDocRef.update({
      'beaches': currentFavorites,
    });
  }
}
