import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';


class Guidefirebaseauthservice {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabase= FirebaseFirestore.instance;

  Future<void> guideRegister({required String email,
  required String Phone_number,
  required String username,
  required String password,
  required String aadhar,
  required BuildContext context}) async {
    try{

      final user= await firebaseAuth.createUserWithEmailAndPassword(email:email, password:password);
      firestoreDatabase.collection('Guide').doc(user.user?.uid).set({
        'name': username,
        'useremail': email,
        'password' : password,
        'aadhar': aadhar,
        'phone number': Phone_number,
      });
      firestoreDatabase
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'Guide'});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registration Sucessfull')));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registration Failed')));
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
          .collection('Users')
          .where('useremail', isEqualTo: email)
          .get();

          print('ggg');
          

      if (userDoc.docs.isEmpty) {
        // If no matching email is found in Firestore
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email not registered')));
      }

     

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));
          
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${e.toString()}')));
    }
  }
}
