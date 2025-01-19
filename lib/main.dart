import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home:MainPage()));} 