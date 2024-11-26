import 'package:flutter/material.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 70, 182, 235),
        title: Text('Admin Homepage'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50), // Add space of 50 pixels from the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), // Added padding for left and right
            child: Row(
              children: [
                // First Container with "Users" label
                Container(
                  alignment: Alignment(100, 50),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Users',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Add space between the two boxes
                // Container with "Guide" label and blue background
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Blue color for the container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Guide',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 253, 243, 243), // Light text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
