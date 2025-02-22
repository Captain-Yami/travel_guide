import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_homepage.dart';
import 'package:travel_guide/home/admin/screen/Admin_Homepage.dart';
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';

class LoginServiceFire {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabse = FirebaseFirestore.instance;

  Future<void> LoginService({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in with email and password
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Logged in user UID: ${userCredential.user?.uid}');

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        final role = await firestoreDatabse
            .collection('role_tb')
            .where('uid', isEqualTo: userCredential.user?.uid)
            .get();

        if (role.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User role not found')),
          );
          return;
        }

        final roledata = role.docs.first.data();
        print(roledata);

        switch (roledata['role']) {
          case 'Users':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ));
            break;
          case 'Guide':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuideHomepage(),
                ));
            break;
          case 'hotels':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HotelHomepage(),
                ));
            break;
          case 'Admin':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomepage(),
                ));
            break;
        }

        // Optionally, navigate to another screen after successful login
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }
}
