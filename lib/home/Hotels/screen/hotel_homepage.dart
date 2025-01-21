import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_addroom.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_bookings.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_viewroom.dart';

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  int _currentIndex = 0; // for the bottom navigation bar

  // Function to update the index on bottom navigation bar item tap
  void onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to corresponding pages based on the index
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelViewroom()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  HotelAddroom()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  HotelBookings()),
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
        title: const Text('Hotel Homepage'),
      ),
      body: Column(
        children: [
          // Carousel Slider (directly specifying images without using a list)
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9, // Adjust aspect ratio as needed
              viewportFraction: 1.0,
            ),
            items: [
              // Image 1 from assets
              Image.asset(
                'assets/images/hotel1.0.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300, // Set a fixed height for the images
              ),
              // Image 2 from assets
              Image.asset(
                'assets/images/hotel1.1.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              // Image 3 from assets
              Image.asset(
                'assets/images/hotel1.2.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
            ],
          ),
          // Additional content can be added here for the hotel homepage
          Expanded(
            child: Center(
              child: Text('Current index: $_currentIndex'),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onNavItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            label: 'View Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Add Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'View Bookings',
          ),
        ],
      ),
    );
  }
}
