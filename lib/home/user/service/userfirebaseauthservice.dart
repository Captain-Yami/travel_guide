import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Userfirebaseauthservice {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabase= FirebaseFirestore.instance;

  Future<void> UserRegister({required String email,
  required String username,
  required String password,
  required String DOB,
  required String address,
  required String pincode,
  required String state,
  required String city,
  required String nation,
  required BuildContext context}) async {
    try{

      final user= await firebaseAuth.createUserWithEmailAndPassword(email:email, password:password);
      firestoreDatabase.collection('users').doc(user.user?.uid).set({
        'name': username,
        'useremail': email,
        'password' : password,
        'DOB': DOB,
        'address' : address,
        'pincode' : pincode,
        'state' : state,
        'city' : city,
        'nation' : nation
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registration Sucessfull')));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registration Failed')));
    }
  }
}