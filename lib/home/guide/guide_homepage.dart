import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/guide_profile.dart';
import 'package:travel_guide/home/guide/req.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/place/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/seasons/season.dart';
import 'package:travel_guide/home/start.dart';
import 'package:travel_guide/home/user/Recent.dart';
import 'package:travel_guide/home/user/User_profile.dart';
import 'package:travel_guide/home/user/favorites.dart';

class GuideHomepage extends StatefulWidget {
  const GuideHomepage({super.key});

  @override
  State<GuideHomepage> createState() => _MainPageState();
}

class _MainPageState extends State<GuideHomepage> {
  final _searchcontroller = TextEditingController();

  // Navigation functions for each page
  void _navigateToreq() {
    // Make sure 'req' class is defined or replace it with a valid screen
    print("Navigating to Requests & Booking page");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const req()), // Replace with actual destination widget
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
        // No need to push a new page, just update the body
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 24, 24, 24), const Color.fromARGB(255, 251, 249, 251)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 400, // Set the width of the TextFormField
                        height: 60, // Set the height of the TextFormField
                        child: TextFormField(
                          controller: _searchcontroller,
                          decoration: InputDecoration(
                            hintText: 'Search', // Optional hint text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), // Oval shape
                              borderSide: const BorderSide(color: Color.fromARGB(255, 5, 0, 0), width: 2), // Border color and thickness
                            ),
                            suffixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 1, 2, 3)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding to adjust the internal space
                          ),
                          style: const TextStyle(fontSize: 18), // Font size inside the text field
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // "Requests & Booking" Button
              Container(
                width: 350,
                height: 50,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _navigateToreq,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Requests & Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              // "Start your journey" button
              Container(
                width: 350,
                height: 50,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _navigateToreq,
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
