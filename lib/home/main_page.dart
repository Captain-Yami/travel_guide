import 'package:flutter/material.dart';
import 'package:travel_guide/home/guidedetails.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/home/season.dart';
import 'package:travel_guide/home/start.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'asset/logo3.jpg', // Replace with your logo path
                fit: BoxFit.cover,
                height: 40,
                width:
                    40, // Make the width and height equal for a perfect circle
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
      body: SingleChildScrollView(  // Wrap the entire body in a SingleChildScrollView
        child: Column(
          children: [
            // Container above the GridView
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/background.jpg'),fit: BoxFit.cover)),
              margin: const EdgeInsets.all(10), // Space between buttons
              child: ElevatedButton(
                onPressed: _navigateTorecommended,
                style: ElevatedButton.styleFrom(elevation: 0,
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
            // The GridView below the Container
            Container(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                shrinkWrap: true, // Makes GridView take up only the space it needs
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10, // Horizontal space between items
                mainAxisSpacing: 10, // Vertical space between items
                children: [
                  // Button 1: Place
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _navigateToplace,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 40),
                          SizedBox(height: 8),
                          Text('Place', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  // Button 2: Guide
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _navigateToguidedetails,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 40),
                          SizedBox(height: 8),
                          Text('Guide', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  // Button 3: Hotel
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _navigateTohotel,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hotel, size: 40), // Hotel icon
                          SizedBox(height: 8),
                          Text('Hotel', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  // Button 4: Season
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _navigateToseason,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 40), // Season icon
                          SizedBox(height: 8),
                          Text('Season', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350,
              height: 50,
              margin: const EdgeInsets.all(10), // Space between buttons
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
    );
  }
}
