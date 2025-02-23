import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_guide/home/hotel.dart';
import 'package:travel_guide/home/user/guidechat.dart';
import 'package:travel_guide/home/user/screen/guidedetails.dart';
import 'package:travel_guide/home/user/screen/place/place.dart';
import 'package:travel_guide/home/user/screen/requests.dart';
import 'package:travel_guide/home/user/screen/start.dart';
import 'package:travel_guide/home/user/screen/User_profile.dart';
import 'package:travel_guide/home/user/screen/favorites.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
    checkCondition();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _navigateToHotel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotelPage()),
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

  void _navigateToRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Requests()),
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
            userLocation: {
              'latitude': position.latitude,
              'longitude': position.longitude
            },
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

  Future<void> checkCondition() async {
    print('enetring');
    String? currentUserId = _auth.currentUser?.uid; // Get logged-in user ID
    if (currentUserId == null) return; // Exit if user is not logged in

    try {
      final prefs = await SharedPreferences.getInstance();
      String lastPopupDate =
          prefs.getString('lastPopupDate_$currentUserId') ?? '';

      // Get today's date
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // If pop-up was already shown today, exit
      if (lastPopupDate == todayDate) {
        debugPrint("Pop-up already shown today. Skipping...");
        return;
      }
      // Query Firestore to find a matching document where the user ID matches
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('confirmed_requests')
          .where('user', isEqualTo: currentUserId) // Match user ID
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Fetch the guideId from the first matching document
        String guideId = querySnapshot.docs.first['guideId'];
        debugPrint("Fetched guideId: $guideId");

        // Show pop-up since the condition is met
        DocumentSnapshot<Map<String, dynamic>> guideDoc =
            await _firestore.collection('Guide').doc(guideId).get();

        if (guideDoc.exists) {
          bool status = guideDoc.data()?['status'] ?? false;
          bool reqAccept = guideDoc.data()?['reqAccept'] ?? false;

          if (status && reqAccept) {
      debugPrint("Conditions met, showing pop-up...");
      if (context.mounted) {
        showConfirmationPopup(currentUserId);
      }
    } else {
      debugPrint("Conditions not met, pop-up will not be shown.");
    }
        }
      }
    } catch (e) {
      debugPrint("Error checking condition: $e");
    }
  }

  void showConfirmationPopup(String currentUserId) {
    if (!context.mounted) return; 
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("guide information"),
          content: Text(
              "Your Guide is out of order.Request for another guide if needed"),
          actions: [
            TextButton(
              onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              
              // Store today's date as the last shown date
              String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
              await prefs.setString('lastPopupDate_$currentUserId', todayDate);

              Navigator.pop(context); // Close the dialog
            },
            child: Text("OK"),
            ),
          ],
        );
      },
    );
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
          MaterialPageRoute(builder: (context) => const Favorites()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatsPageguide()),
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
            const SizedBox(width: 10), // Adjust spacing
            Expanded(
              child: Text(
                'Travel Chronicles',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 251, 250, 250),
                ),
                overflow: TextOverflow
                    .ellipsis, // This will prevent overflow when the text is too long
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ],
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
                          child: InkWell(
                            onTap: _navigateToHotel,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'asset/hotel_icon.png', // Adjust path if needed
                                      height: 50, // Adjust the size as needed
                                      width: 50, // Adjust the size as needed
                                      fit: BoxFit
                                          .contain, // Ensures the image fits properly
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Hotel',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: _navigateToGuideDetails,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Image.asset('asset/guide_icon.png',
                                        height: 50),
                                    const SizedBox(height: 8),
                                    Text('Guide',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.green)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: _navigateToRequests,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Image.asset('asset/guide_icon.png',
                                        height: 50),
                                    const SizedBox(height: 8),
                                    Text('Requests',
                                        style: GoogleFonts.roboto(
                                            fontSize: 16, color: Colors.green)),
                                  ],
                                ),
                              ),
                            ),
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
                            icon: Icons.location_on_outlined,
                            label: 'Place',
                            color: Colors.green,
                            onPressed: _navigateToPlace,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  minimumSize: Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.green,
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
            icon: Icon(Icons.favorite),
            label: 'Favorites',
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
        unselectedItemColor: const Color.fromARGB(255, 52, 51, 51),
        backgroundColor: Colors.black,
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
