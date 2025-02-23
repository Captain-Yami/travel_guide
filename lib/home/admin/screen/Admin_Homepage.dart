import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase import
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication
import 'package:travel_guide/home/admin/places/hotels.dart';
import 'package:travel_guide/home/admin/screen/add_places.dart';
import 'package:travel_guide/home/admin/screen/admin_guides.dart';
import 'package:travel_guide/home/admin/screen/admin_ratings.dart';
import 'package:travel_guide/home/admin/screen/admin_complaints.dart';
import 'package:travel_guide/home/admin/screen/admin_users.dart';
import 'package:travel_guide/home/admin/screen/approveGuide.dart';
import 'package:travel_guide/home/admin/screen/hotel_managment.dart';
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

  void navigateToHotelApproval() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HotelManagment()), // Navigate to the hotel approval page
    );
  }
void navigateToGuideApproval() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GuideApproval()), // Navigate to the hotel approval page
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
        backgroundColor: const Color.fromRGBO(12, 22, 21, 1), // Dark black
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align buttons at the top
              children: [
                const SizedBox(height: 20),
                // Vertical Buttons Section
                FutureBuilder<int>(
                  future: fetchUserCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error fetching user count'));
                    }
                    int userCount = snapshot.data ?? 0;
                    return Column(
                      children: [
                        // Users Button - Left Side
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 250, // Set the width for this button
                            height: 100, // Set the height for this button
                            child: ElevatedButton.icon(
                              onPressed: navigateToUsers,
                              icon: const Icon(Icons.people,
                                  size: 32, color: Colors.black),
                              label: Text('Users ($userCount)',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Guide Button - Right Side
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 300, // Set the width for this button
                            height: 120, // Set the height for this button
                            child: ElevatedButton.icon(
                              onPressed: navigateToGuides,
                              icon: const Icon(Icons.book,
                                  size: 32, color: Colors.black),
                              label: const Text('Guide',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Complaints Button - Left Side
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 300,
                            height: 110,
                            child: ElevatedButton.icon(
                              onPressed: navigateToComplaints,
                              icon: const Icon(Icons.report,
                                  size: 32, color: Colors.black),
                              label: const Text('Complaints',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add Places Button - Right Side
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 280, // Set a smaller width for this button
                            height: 130, // Set a larger height for this button
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPlacesPage()),
                                );
                              },
                              icon: const Icon(Icons.add_location,
                                  size: 32, color: Colors.black),
                              label: const Text('Add Places',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add Hotels Button - Left Side
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 320, // Set a larger width for this button
                            height: 100, // Set a medium height for this button
                            child: ElevatedButton.icon(
                              onPressed: navigateToHotels,
                              icon: const Icon(Icons.hotel,
                                  size: 32, color: Colors.black),
                              label: const Text('Add Hotels',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Approve Hotels Button - Right Side
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 320,
                            height: 100,
                            child: ElevatedButton.icon(
                              onPressed: navigateToHotelApproval,
                              icon: const Icon(Icons.check_circle,
                                  size: 32, color: Colors.black),
                              label: Text('Approve Hotels',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 320,
                            height: 100,
                            child: ElevatedButton.icon(
                              onPressed: navigateToGuideApproval,
                              icon: const Icon(Icons.check_circle,
                                  size: 32, color: Colors.black),
                              label: Text('Approve Guides',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 24),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Rounded edges
                                ),
                                minimumSize: const Size(300, 80),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
