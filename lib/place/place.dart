import 'package:flutter/material.dart';
import 'package:travel_guide/place/beaches.dart';
import 'package:travel_guide/place/temples.dart';
import 'package:travel_guide/place/forts.dart';
import 'package:travel_guide/place/trekking_spots.dart';

class Place extends StatefulWidget {
  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  // Define navigation for each button
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
      MaterialPageRoute(builder: (context) => const MuseumsAndFort()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(202, 19, 154, 216),
        title: const Text('Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2, // 2 buttons per row
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 10, // Space between rows
          children: [
            // Button 1: Beaches
            ElevatedButton(
              onPressed: _navigateToBeaches,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blueAccent, // Customize button color
              ),
              child: const Text(
                'Beaches',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Button 2: Temples
            ElevatedButton(
              onPressed: _navigateToTemples,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green, // Customize button color
              ),
              child: const Text(
                'Temples',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Button 3: Trekking Spots
            ElevatedButton(
              onPressed: _navigateToTrekkingSpots,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.brown, // Customize button color
              ),
              child: const Text(
                'Trekking Spots',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Button 4: Museums and Forts
            ElevatedButton(
              onPressed: _navigateToMuseumsAndForts,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.purple, // Customize button color
              ),
              child: const Text(
                'Museums & Forts',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
