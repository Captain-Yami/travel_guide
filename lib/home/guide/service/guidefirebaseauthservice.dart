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
  
}
