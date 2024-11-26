
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/availability,dart';
import 'package:travel_guide/home/guide/guide_profile.dart';
import 'package:travel_guide/home/guide/req.dart';
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
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex); // Initialize PageController
  }

  // Navigation functions for each page
  void _navigateToreq() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const req()), // Replace with actual destination widget
    );
  }

  void _navigateToAvailability() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Availability()), // Replace with actual destination widget
    );
  }

  // Page navigation for BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 300), // Duration for the slide animation
      curve: Curves.ease, // You can change this for different effects
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
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
            const SizedBox(width: 120), // Space between logo and text
            const Text(
              'Travel Chronicles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 253, 253),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active), 
            color: Colors.white,
            onPressed: () {
              // Add your notification functionality here
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 251, 249, 251),
              const Color.fromARGB(255, 251, 249, 251)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            _buildHomePage(),
            const Recent(),
            const Favorites(),
            const UserProfile(),
          ],
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
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        unselectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    width: 400, // Set the width of the TextFormField
                    height: 60, // Set the height of the TextFormField
                    child: TextFormField(
                      controller: _searchcontroller,
                      decoration: InputDecoration(
                        hintText: 'Search', // Optional hint text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Oval shape
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 5, 0, 0),
                            width: 2, // Border color and thickness
                          ),
                        ),
                        suffixIcon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 1, 2, 3)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20), // Padding to adjust the internal space
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Requests & Booking" Button
          Container(
            width: 400,
            height: 150,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _navigateToreq,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   const SizedBox(width: 30),
                  Image.asset(
                    'asset/req_icon.png', // Path to your custom image asset
                    width: 70, // Set the width of the icon
                    height: 70, // Set the height of the icon
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Requests & Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 5, 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Start your journey" button
Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 400, // Set the width of the TextFormField
                    height: 200, // Set the height of the TextFormField
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.3, // Square aspect ratio (width == height)
                      children: [
                        // Button 1: Place
                        _buildGridButton(
                          icon: Icons.event_available,
                          label: 'Availability',
                          onPressed: _navigateToAvailability,
                        ),
                        // Button 2: Guide
                        _buildGridButton(
                          icon: Icons.star,
                          label: 'Ratings',
                          onPressed: _navigateToreq,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          backgroundColor: const Color.fromARGB(255, 240, 240, 240), // Set button color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color.fromARGB(255, 8, 8, 8)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}