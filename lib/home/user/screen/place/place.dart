import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/place/beaches.dart';
import 'package:travel_guide/home/user/screen/place/temples.dart';
import 'package:travel_guide/home/user/screen/place/forts.dart';
import 'package:travel_guide/home/user/screen/place/trekking_spots.dart';

class Place extends StatefulWidget {
  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  // Define navigation for each card
  void _navigateToBeaches() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Beaches()),
    );
  }

  void _navigateToTemples() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Temples()),
    );
  }

  void _navigateToTrekkingSpots() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrekkingSpots()),
    );
  }

  void _navigateToMuseumsAndForts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FortsAndMuseums()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        title: Row(
          children: [
            const SizedBox(width: 150),
            const Text(
              'Place',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 253, 253),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 20, // Space between rows
          childAspectRatio: 2, // Adjust the aspect ratio to control the button size
          children: [
            // Button 1: Beaches
            ElevatedButton(
              onPressed: _navigateToBeaches,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 171, 167, 171),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.beach_access_rounded, size: 30, color: Colors.black),
                  SizedBox(height: 8),
                  Text(
                    'Beaches',
                    style: TextStyle(fontSize: 16, color: Colors.black), // Medium font size
                  ),
                ],
              ),
            ),

            // Button 2: Temples
            ElevatedButton(
              onPressed: _navigateToTemples,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor:const Color.fromARGB(255, 171, 167, 171),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.temple_hindu, size: 30, color: Colors.black), // You can use a temple icon here if available
                  SizedBox(height: 8),
                  Text(
                    'Temples',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Button 3: Trekking Spots
            ElevatedButton(
              onPressed: _navigateToTrekkingSpots,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 171, 167, 171),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.directions_walk, size: 30, color: Colors.black), // Trekking icon
                  SizedBox(height: 8),
                  Text(
                    'Trekking Spots',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Button 4: Museums & Forts
            ElevatedButton(
              onPressed: _navigateToMuseumsAndForts,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor:const Color.fromARGB(255, 171, 167, 171),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.castle, size: 30, color: Colors.black), // Forts & Museums icon
                  SizedBox(height: 8),
                  Text(
                    'Museums & Forts',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
