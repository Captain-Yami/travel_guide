import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/place/beaches.dart';
import 'package:travel_guide/home/user/place/temples.dart';
import 'package:travel_guide/home/user/place/forts.dart';
import 'package:travel_guide/home/user/place/trekking_spots.dart';

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
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 10, // Space between rows
          children: [
            // Card 1: Beaches
            GestureDetector(
              onTap: _navigateToBeaches,
              child: Card(
                color: Colors.blueAccent, // Card color
                elevation: 5, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: const Text(
                    'Beaches',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            // Card 2: Temples
            GestureDetector(
              onTap: _navigateToTemples,
              child: Card(
                color: Colors.green, // Card color
                elevation: 5, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: const Text(
                    'Temples',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            // Card 3: Trekking Spots
            GestureDetector(
              onTap: _navigateToTrekkingSpots,
              child: Card(
                color: Colors.brown, // Card color
                elevation: 5, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: const Text(
                    'Trekking Spots',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            // Card 4: Museums and Forts
            GestureDetector(
              onTap: _navigateToMuseumsAndForts,
              child: Card(
                color: Colors.purple, // Card color
                elevation: 5, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: const Text(
                    'Museums & Forts',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
