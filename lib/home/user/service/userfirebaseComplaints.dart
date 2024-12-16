import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Function to save feedback to Firestore
Future<void> saveFeedback(String feedback) async {
  try {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;
    
    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Save the feedback in the Complaints collection
    await firestore.collection('Complaints').add({
      'user_id': uid, // Save the user ID
      'feedback': feedback, // Save the actual feedback content
      'timestamp': FieldValue.serverTimestamp(), // Save the timestamp
    });

    print('Feedback submitted successfully!');
  } catch (e) {
    // Handle any errors that occur during the save process
    print('Error submitting feedback: $e');
  }
}
