import 'package:flutter/material.dart';
import 'package:travel_guide/home/admin/screen/Admin_Homepage.dart';
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';
import 'package:travel_guide/home/guide/screen/guide_signup.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';
import 'package:travel_guide/home/user/screen/place/beaches.dart';
import 'package:travel_guide/home/user/screen/signup.dart';
//import 'package:travel_guide/home/admin/admin_hotels.dart';
//import 'package:travel_guide/guide/page/guide_signup.dart';
//import 'package:travel_guide/home/guide/guide_homepage.dart';
/*import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/user/UserHomePage.dart';
import 'package:travel_guide/home/user/User_profile.dart';
import 'package:travel_guide/seasons/season.dart';
import 'package:travel_guide/select_user.dart';
import 'package:travel_guide/intro.dart';
import 'package:travel_guide/home/user/login_page.dart';
import 'package:travel_guide/home/user/signup.dart';
import 'package:travel_guide/home/user/details.dart';
import 'package:travel_guide/guide/page/guide_signup.dart';
import 'package:travel_guide/home/user/favorites.dart';
import 'package:travel_guide/home/user/Recent.dart';
import 'package:travel_guide/home/guide/guide_profile.dart';*/
import 'package:travel_guide/home/admin/screen/Admin_Homepage.dart';
import 'package:travel_guide/home/admin/screen/admin_users.dart';
import 'package:travel_guide/home/admin/screen/add_places.dart';
import 'package:travel_guide/home/user/screen/UserHomePage.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';
import 'package:travel_guide/home/user/screen/start.dart';
import 'package:travel_guide/intro.dart';
//import 'package:travel_guide/home/user/place/place.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_guide/schedule.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home:Start()));}
  
 
