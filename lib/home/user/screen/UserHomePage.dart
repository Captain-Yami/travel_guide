import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import the carousel_slider package
import 'package:geolocator/geolocator.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/user/guidechat.dart';
import 'package:travel_guide/home/user/screen/guidedetails.dart';
import 'package:travel_guide/home/user/screen/place/place.dart';
import 'package:travel_guide/home/recommended.dart';
import 'package:travel_guide/home/user/screen/start.dart';
import 'package:travel_guide/home/user/screen/Recent.dart';
import 'package:travel_guide/home/user/screen/User_profile.dart';
import 'package:travel_guide/home/user/screen/favorites.dart';
import 'package:google_fonts/google_fonts.dart';  // Import google_fonts package

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _navigateToHotel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const hotel()),
    );
  }

  void _navigateToPlace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Place()),
    );
  }

  void _navigateToGuideDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Guidedetails()),
    );
  }

  void _navigateToguidechats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatsPageguide()),
    );
  }

  void _navigateToRecommended() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Recommended()),
    );
  }

 
  Future<void> _navigateToStart() async {
    try {
      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Navigate to the "Start" screen and pass the location
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Start(
            userLocation: {'latitude': position.latitude, 'longitude': position.longitude},
          ),
        ),
      );
    } catch (e) {
      // Show an error dialog if location retrieval fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
 

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
                'asset/logo3.jpg',
                fit: BoxFit.cover,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 120),
            Text(
              'Travel Chronicles',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 251, 250, 250),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 242, 240, 240), const Color.fromARGB(255, 242, 238, 238)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.all(10),
                child: CarouselSlider(
                  items: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'asset/pic1.jpg',
                        fit: BoxFit.cover,
                        height: 200,
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.location_on_outlined,
                            label: 'Place',
                            color: const Color.fromARGB(255, 171, 167, 171),
                            onPressed: _navigateToPlace,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.group_outlined,
                            label: 'Guide',
                            color: const Color.fromARGB(255, 171, 167, 171),
                            onPressed: _navigateToGuideDetails,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.location_city_outlined,
                            label: 'Hotel',
                            color: const Color.fromARGB(255, 171, 167, 171),
                            onPressed: _navigateToHotel,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildElevatedButton(
                            icon: Icons.chat,
                            label: 'Chats',
                            color: const Color.fromARGB(255, 171, 167, 171),
                            onPressed: _navigateToguidechats,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
  onPressed: _navigateToStart,
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Increase padding
    minimumSize: Size(200, 60), // Increase height and make it stretch across the screen
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text(
    'Start your journey',
    style: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
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
          backgroundColor: Colors.black
      ),
    );
  }

  Widget _buildElevatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: color,
        elevation: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
