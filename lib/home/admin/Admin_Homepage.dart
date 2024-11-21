import 'package:flutter/material.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  // Define navigation or functionality for each button
  void _navigateToUsers() {
    // Placeholder for Users button
    print("Navigating to Users");
  }

  void _navigateToGuides() {
    // Placeholder for Guide button
    print("Navigating to Guides");
  }

  void _navigateToHotels() {
    // Placeholder for Hotels button
    print("Navigating to Hotels");
  }

  void _navigateToPlaces() {
    // Placeholder for Places button
    print("Navigating to Places");
  }

  void _navigateToComplaints() {
    // Placeholder for Complaints button
    print("Navigating to Complaints");
  }

  void _navigateToReviews() {
    // Placeholder for Reviews button
    print("Navigating to Reviews");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(202, 19, 154, 216),
        title: const Text('Admin Homepage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two buttons in each row
          crossAxisSpacing: 20, // Space between buttons horizontally
          mainAxisSpacing: 20, // Space between buttons vertically
          children: [
            ElevatedButton(
              onPressed: _navigateToUsers,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Users',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToGuides,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Guides',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToHotels,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Hotels',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToPlaces,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Places',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToComplaints,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Complaints',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToReviews,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6), // Reduced padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                'Reviews',
                style: TextStyle(fontSize: 14, color: Colors.white), // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
