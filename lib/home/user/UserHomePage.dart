import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/guide_profile.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/home/season.dart';
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
  void _navigateTohotel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const hotel()),
    );
  }

  void _navigateToplace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const place()),
    );
  }

  void _navigateToguidedetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const guidedetails()),
    );
  }

  void _navigateToseason() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const season()),
    );
  }

  void _navigateTorecommended() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Recommended()),
    );
  }

  void _navigateTostart() {
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
        // Navigate to the Home Page (or main page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
        break;
      case 1:
        // Navigate to the Clock Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Recent()),
        );
        break;
      case 2:
        // Navigate to the Favorites Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Favorites()),
        );
        break;
      case 3:
        // Navigate to the Profile Page
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
              // You can add search functionality here
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
                  onPressed: _navigateTorecommended,
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
                    Container(
                      width: 100, // Reduced width of container
                      height: 100, // Reduced height of container
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: _navigateToplace,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 1,
                              child: Icon(Icons.map, size: 30, color: Colors.purple), // Reduced icon size
                            ),
                            const SizedBox(height: 8),
                            const Text('Place', style: TextStyle(fontSize: 14)), // Reduced text size
                          ],
                        ),
                      ),
                    ),
                    // Button 2: Guide
                    Container(
                      width: 100, // Reduced width of container
                      height: 100, // Reduced height of container
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: _navigateToguidedetails,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 1,
                              child: Icon(Icons.map, size: 30, color: Colors.purple), // Reduced icon size
                            ),
                            const SizedBox(height: 8),
                            const Text('Guide', style: TextStyle(fontSize: 14)), // Reduced text size
                          ],
                        ),
                      ),
                    ),
                    // Button 3: Hotel
                    Container(
                      width: 100, // Reduced width of container
                      height: 100, // Reduced height of container
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: _navigateTohotel,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 1,
                              child: Icon(Icons.hotel, size: 30, color: Colors.purple), // Reduced icon size
                            ),
                            const SizedBox(height: 8),
                            const Text('Hotel', style: TextStyle(fontSize: 14)), // Reduced text size
                          ],
                        ),
                      ),
                    ),
                    // Button 4: Season
                    Container(
                      width: 100, // Reduced width of container
                      height: 100, // Reduced height of container
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: _navigateToseason,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 1,
                              child: Icon(Icons.calendar_today, size: 30, color: Colors.purple), // Reduced icon size
                            ),
                            const SizedBox(height: 8),
                            const Text('Season', style: TextStyle(fontSize: 14)), // Reduced text size
                          ],
                        ),
                      ),
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
                  onPressed: _navigateTostart,
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
}
