import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_homepage.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';

class hotelfirebaseauthservice {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabase = FirebaseFirestore.instance;
  bool isApproved = false;

  Future<void> hotelRegister(
      {required String email,
      required String Phone_number,
      required String hotelName,
      required String password,
      required int numberOfRooms,
      required String location,
      required String facilities,
      required String? imageUrl,
      required String? documnetUrl,
      required BuildContext context}) async {
    try {
      print('.............');
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      String userId = user.user!.uid;

      print('vysakh');
      firestoreDatabase.collection('hotels').doc(userId).set({
        'hotelName': hotelName,
        'contactEmail': email,
        'contactNumber': Phone_number,
        'document': documnetUrl,
        'facilities': facilities,
        'imageUrl': imageUrl,
        'location': location,
        'numberOfRooms': numberOfRooms,
        'ownerId': userId,
        'isApproved': isApproved,
      });
      print('kkkkkkkkkkkkk');
      firestoreDatabase
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'hotels'});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Sucessfull')));
    } catch (e) {
      print('Registration Failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Failed')));
    }
  }

  Future<void> userLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Query Firestore to find a user document with the matching email
      // If the email exists, proceed to authenticate the password
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      print(email);
      final userDoc = await firestoreDatabase
          .collection('hotels')
          .where('contactEmail', isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        // If no matching email is found in Firestore
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email not registered')));
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'hotel-not-found':
          errorMessage = 'No hotel found with this email.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${e.toString()}')));
    }
  }
}
