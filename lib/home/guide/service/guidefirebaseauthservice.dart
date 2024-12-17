import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';


class Guidefirebaseauthservice {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabase= FirebaseFirestore.instance;

  Future<void> guideRegister({
  required String email,
  required String Phone_number,
  required String username,
  required String password,
  required String aadhar,
  required String License,
  required String licenseImageUrl,
  required BuildContext context,
}) async {
  try {
    // Register the user with Firebase Authentication
    final user = await firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
    
    // Add the guide's details to Firestore under 'Guide' collection
    await firestoreDatabase.collection('Guide').doc(user.user?.uid).set({
      'name': username,
      'gideemail': email,
      'password': password,
      'aadhar': aadhar,
      'phone number': Phone_number,
      'License': License,
      'licenseImageUrl': licenseImageUrl,
    });

    // Add the role information to the 'role_tb' collection
    await firestoreDatabase.collection('role_tb').add({
      'uid': user.user?.uid,
      'role': 'Guide',
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful')));
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Failed')));
  }
}

  Future<void> userLogin({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    // Sign in the user
    final user = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );

    // Retrieve the user's `uid`
    String uid = user.user?.uid ?? '';
    
    // Check if the user exists in the Firestore 'Users' collection
    final userDoc = await firestoreDatabase
        .collection('Guide')
        .where('guideemail', isEqualTo: email)
        .get();

    if (userDoc.docs.isEmpty) {
      // If no matching email is found in Firestore, show error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email not registered')));
      return;
    }

    // Proceed with successful login
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));

    // Now, navigate to the Guide Homepage
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const GuideHomepage())
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again.';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
        break;
      default:
        errorMessage = 'An error occurred. Please try again.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed: ${e.toString()}')));
  }
}
}

