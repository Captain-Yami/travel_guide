import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Function to add or remove a beach from the user's favorites
Future<void> updateFavoriteStatus(String favouriteId, Map<String, dynamic> beach, bool isFavorite) async {
  if (currentUser == null) {
    throw Exception("User not authenticated.");
  }

  // Reference to the user's document in the Favourites collection
  DocumentReference userDocRef = _firestore.collection('Favourites').doc(currentUser!.uid);

  // Use a transaction to ensure consistency
  await _firestore.runTransaction((transaction) async {
    DocumentSnapshot userDocSnapshot = await transaction.get(userDocRef);

    // Initialize favorites if the document doesn't exist
    List<dynamic> currentFavorites = [];
    if (userDocSnapshot.exists) {
      currentFavorites = (userDocSnapshot.data() as Map<String, dynamic>)['favourites'] ?? [];
    }

    if (isFavorite) {
      // Add the beach to the user's favorites if not already added
      if (!currentFavorites.any((item) => item['favouriteId'] == favouriteId)) {
        currentFavorites.add({
          'beachId': favouriteId,
          'name': beach['name'],
          'description': beach['description'],
          'imageUrl': beach['imageUrl'],
        });
      }
    } else {
      // Remove the beach from the user's favorites
      currentFavorites.removeWhere((item) => item['beachId'] == favouriteId);
    }

    // Update or set the document with the updated favorites
    transaction.set(userDocRef, {'favourites': currentFavorites});
  });
}

}
