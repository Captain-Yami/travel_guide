/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class firebaseAddtemples {
  final FirebaseFirestore firebase = FirebaseFirestore.instance;

  // Function to add a place to the 'beaches' collection
  Future<void> addtemples({
    required String locationName,
    required String locationDescription,
    required String seasonalTime,
    required String openingTime,
    required String closingTime,
  }) async {
    try {
      // Reference to the 'places' collection, and 'beaches' sub-collection
      CollectionReference places = firebase.collection('Places');
      CollectionReference beaches = places.doc('Locations').collection('Temples');
      
      // Creating a new document in the 'beaches' collection
      await beaches.add({
        'location_name': locationName,
        'location_description': locationDescription,
        'pilgrimage_time': seasonalTime,
        'opening_time': openingTime,
        'closing_time': closingTime,
      });

      print('Place added successfully!');
    } catch (e) {
      print('Error adding place: $e');
    }
  }
}*/

