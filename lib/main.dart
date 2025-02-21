import 'package:flutter/material.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_homepage.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_login.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_registration.dart';
import 'package:travel_guide/home/admin/screen/Admin_Homepage.dart';
import 'package:travel_guide/home/admin/screen/hotel_managment.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_guide/intro.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home:HotelLoginPage()));} 