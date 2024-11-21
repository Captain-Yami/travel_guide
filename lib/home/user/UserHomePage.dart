import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/guide_profile.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/place/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/seasons/season.dart';
import 'package:travel_guide/home/start.dart';
import 'package:travel_guide/home/user/Recent.dart';
import 'package:travel_guide/home/user/User_profile.dart';
import 'package:travel_guide/home/user/favorites.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Navigation functions for each page
  void _navigateToHotel() {
    print('Navigating to Hotel page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const hotel()),
    );
  }

  void _navigateToPlace() {
    print('Navigating to Place page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Place()),
    );
  }

  void _navigateToGuideDetails() {
    print('Navigating to Guide page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Guidedetails()),
    );
  }

  void _navigateToSeason() {
    print('Navigating to Season page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Season()),
    );
  }

  void _navigateToRecommended() {
    print('Navigating to Recommended page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Recommended()),
    );
  }

  void _navigateToStart() {
    print('Navigating to Start your Journey page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const start()),
    );
  }

  // Page navigation for BottomNavigationBar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Recent()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Favorites()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(202, 19, 154, 216),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'asset/logo3.jpg', // Replace with your logo path
                fit: BoxFit.cover,
                height: 40,
                width: 40, // Make the width and height equal for a perfect circle
              ),
            ),
            const SizedBox(width: 70), // Space between logo and text
            const Text(
              'Travel Chronicles',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Search icon
            onPressed: () {
              // Add your search functionality here
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('asset/background4.jpg'), // Add your background image
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _navigateToRecommended,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              // GridView below the Container
              Container(
                padding: const EdgeInsets.all(10),
                height: 400, // Fix the height of the grid view
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    // Button 1: Place
                    _buildGridButton(
                      icon: Icons.map,
                      label: 'Place',
                      onPressed: _navigateToPlace,
                    ),
                    // Button 2: Guide
                    _buildGridButton(
                      icon: Icons.map,
                      label: 'Guide',
                      onPressed: _navigateToGuideDetails,
                    ),
                    // Button 3: Hotel
                    _buildGridButton(
                      icon: Icons.hotel,
                      label: 'Hotel',
                      onPressed: _navigateToHotel,
                    ),
                    // Button 4: Season
                    _buildGridButton(
                      icon: Icons.calendar_today,
                      label: 'Season',
                      onPressed: _navigateToSeason,
                    ),
                  ],
                ),
              ),
              // Start your journey button
              Container(
                width: 350,
                height: 50,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _navigateToStart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start your journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 66, 62, 62),
        unselectedItemColor: const Color.fromARGB(255, 58, 54, 54),
        backgroundColor: Colors.purple,
      ),
    );
  }

  // Helper function to create grid buttons
  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 150, // Adjust width of container
      height: 150, // Adjust height of container
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.purple, // Set button color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
