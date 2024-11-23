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
        backgroundColor:  const Color.fromARGB(255, 70, 182, 235),
        title: Text('Admin Homepage'),
      ),
             body: Column(
        children: [
          SizedBox(height: 50), // Add space of 50 pixels from the top
          Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10), // Add padding to the left
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
        ],
      ),
    );
  }
}