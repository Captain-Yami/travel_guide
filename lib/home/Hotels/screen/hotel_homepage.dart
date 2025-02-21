import 'package:flutter/material.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_addroom.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_bookings.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_viewroom.dart';

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  // Function to navigate to corresponding pages
  void onButtonTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewRooms()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelAddroom()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookedRoomsPage()),
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
        title:
            const Text('Hotel Homepage', style: TextStyle(color: Colors.green)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ], // Three-color gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Row for the first button (View Rooms)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.green, // Circular shape
                      minimumSize: Size(150, 150), // Increased size
                      padding: const EdgeInsets.all(
                          30), // Green color for the button
                    ),
                    onPressed: () => onButtonTapped(0),
                    child: const Text(
                      'View\nRooms',
                      textAlign: TextAlign.center, // Center text in the button
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black), // Black font color
                    ),
                  ),
                ],
              ),
            ),
            // Row for the second button (Add Rooms)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.green, // Circular shape
                      minimumSize: Size(150, 150), // Increased size
                      padding: const EdgeInsets.all(
                          30), // Green color for the button
                    ),
                    onPressed: () => onButtonTapped(1),
                    child: const Text(
                      'Add\nRooms',
                      textAlign: TextAlign.center, // Center text in the button
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black), // Black font color
                    ),
                  ),
                ],
              ),
            ),
            // Row for the third button (View Bookings)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.green, // Circular shape
                      minimumSize: Size(150, 150), // Increased size
                      padding: const EdgeInsets.all(
                          30), // Green color for the button
                    ),
                    onPressed: () => onButtonTapped(2),
                    child: const Text(
                      'View\nBookings',
                      textAlign: TextAlign.center, // Center text in the button
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black), // Black font color
                    ),
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
