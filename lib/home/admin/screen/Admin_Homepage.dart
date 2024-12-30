import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase import
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication
import 'package:fl_chart/fl_chart.dart'; // Import for PieChart
import 'package:travel_guide/home/admin/places/hotels.dart';
import 'package:travel_guide/home/admin/screen/add_places.dart';
import 'package:travel_guide/home/admin/screen/admin_guides.dart';
import 'package:travel_guide/home/admin/screen/admin_ratings.dart';
import 'package:travel_guide/home/admin/screen/admin_complaints.dart';
import 'package:travel_guide/home/admin/screen/admin_users.dart';
import 'package:travel_guide/home/user/screen/login_page.dart'; 
import 'package:travel_guide/home/user/screen/login_page.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int touchedIndex = -1;

  // Navigation functions
  void navigateToUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminUsers()),
    );
  }

  void navigateToGuides() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminGuides()),
    );
  }

  void navigateToRatings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminComplaints()),
    );
  }

  void navigateToComplaints() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminComplaints()),
    );
  }

  void navigateToHotels() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Hotels()),
    );
  }

  Future<int> fetchUserCount() async {
    var snapshot = await FirebaseFirestore.instance.collection('Users').get();
    return snapshot.size;
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Admin Homepage',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 350,
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Analysis',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Success', style: TextStyle(color: Colors.black, fontSize: 14)),
                          SizedBox(height: 10),
                          Text('Failed', style: TextStyle(color: Colors.black, fontSize: 14)),
                          SizedBox(height: 10),
                          Text('Pending', style: TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 50,
                      color: Colors.green,
                      title: 'Best',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'Good',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.red,
                      title: 'Worst',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                  centerSpaceRadius: 30,
                  startDegreeOffset: 90,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<int>(
                      future: fetchUserCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Text('Error fetching user count');
                        }
                        int userCount = snapshot.data ?? 0;
                        return ElevatedButton(
                          onPressed: navigateToUsers,
                          child: Text('Users ($userCount)'),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: navigateToGuides,
                      child: const Text('Guide'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: navigateToComplaints,
                      child: const Text('Complaints'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPlacesPage()),
                        );
                      },
                      child: const Text('Add Places'),
                    ),
                     const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Hotels()),
                        );
                      },
                      child: const Text('Add Hotels'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
