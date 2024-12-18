/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class firebaseAddbeaches {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;

  // Function to add a place to the 'beaches' collection
  Future<void> addbeaches({
    required String locationName,
    required String locationDescription,
    required String seasonalTime,
    required String openingTime,
    required String closingTime,
  }) async {
    try {
      // Reference to the 'places' collection, and 'beaches' sub-collection
      CollectionReference places = firebase.collection('Places');
      CollectionReference beaches = places.doc('Locations').collection('Beaches');
      
      // Creating a new document in the 'beaches' collection
      await beaches.add({
        'name': locationName,
        'description': locationDescription,
        'seasonalTime': seasonalTime,
        'openingTime': openingTime,
        'closingtime': closingTime,
      });

      print('Place added successfully!');
    } catch (e) {
      print('Error adding place: $e');
    }
  }
}*/

