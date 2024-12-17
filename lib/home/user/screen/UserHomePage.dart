/*import 'package:flutter/material.dart';
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
                  // Here is where we set the childAspectRatio
                  childAspectRatio: 2.2, // Adjust this ratio to change button size
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
}*/
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import the carousel_slider package
import 'package:travel_guide/home/guide/screen/guide_profile.dart';
import 'package:travel_guide/home/guide/screen/list_of_guides.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/user/screen/guidedetails.dart';
import 'package:travel_guide/home/user/screen/place/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/home/user/seasons/season.dart';
import 'package:travel_guide/home/start.dart';
import 'package:travel_guide/home/user/screen/Recent.dart';
import 'package:travel_guide/home/user/screen/User_profile.dart';
import 'package:travel_guide/home/user/screen/favorites.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Navigation functions for each page
  final _searchcontroller = TextEditingController();
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
            icon: const Icon(Icons.list), 
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
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
              // Carousel Slider inside the Recommended Section
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.all(10),
                child: CarouselSlider(
                  items: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Adjust the value for desired roundness
                      child: Image.asset(
                        'asset/pic1.jpg',
                        fit: BoxFit.cover,
                        height: 200, // Ensure the image fills the height
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic3.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic4.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic5.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic6.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic7.jpg',
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 3),
                    height: 200,
                    viewportFraction: 1.0,
                  ),
                ),
              ),
              // Elevated Buttons in two rows
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  children: [
                    // First row with two buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Button 1: Place
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.map,
                            label: 'Place',
                            onPressed: _navigateToPlace,
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between buttons
                        // Button 2: Guide
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.map,
                            label: 'Guide',
                            onPressed: _navigateToGuideDetails,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Spacing between rows
                    // Second row with two buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Button 3: Hotel
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.hotel,
                            label: 'Hotel',
                            onPressed: _navigateToHotel,
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between buttons
                        // Button 4: Season
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.calendar_today,
                            label: 'Season',
                            onPressed: _navigateToSeason,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Start your journey button
              Container(
                width: 350,
                height: 50,
                margin: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 240, 240, 240),
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
                      color: Colors.black,
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
        selectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        unselectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      ),
    );
  }

  // Helper function to create ElevatedButton widgets
  Widget _buildElevatedButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240), // Button color
        elevation: 5, // Optional elevation
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.black), // Icon
          const SizedBox(height: 8), // Space between icon and label
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black, // Label text color
            ),
          ),
        ],
      ),
    );
  }
}

