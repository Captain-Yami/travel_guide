import 'package:flutter/material.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_registration.dart';
import 'package:travel_guide/home/guide/screen/guide_signup.dart';
import 'package:travel_guide/home/user/screen/signup.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  void _navigateToGuideSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuideSignup()),
    );
  }

  void _navigateToHotelSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HotelRegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black color for AppBar
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Circular Logo Image
            ClipOval(
              child: Image.asset(
                'asset/logo3.jpg', // Ensure this path is correct
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 60), // Add space after the logo

            // Row to place the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align buttons to center
              children: <Widget>[
                _buildUserButton(),
                _buildGuideButton(),
                _buildHotelButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserButton() {
    return _buildButton(
      onPressed: _navigateToSignup,
      icon: Icons.person,
      label: 'User',
    );
  }

  Widget _buildGuideButton() {
    return _buildButton(
      onPressed: _navigateToGuideSignup,
      icon: Icons.map,
      label: 'Guide',
    );
  }

  Widget _buildHotelButton() {
    return _buildButton(
      onPressed: _navigateToHotelSignup,
      icon: Icons.hotel,
      label: 'Hotel',
    );
  }

  Widget _buildButton({required VoidCallback onPressed, required IconData icon, required String label}) {
    return Container(
      width: 120, // Adjusted width for three buttons
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}