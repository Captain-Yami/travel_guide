import 'package:flutter/material.dart';
import 'package:travel_guide/guide/page/guide_signup.dart';
import 'package:travel_guide/user/page/signup.dart';

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

  void _navigateToguidesignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuideSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.8, // Adjust opacity of the background image
              child: Image.asset(
                'asset/background3.jpg', // Make sure the path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top of the background image
          Center(
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
                const SizedBox(height: 20), // Add space after the logo

                // "User" Button
                Container(
                  width: 150, // Width of the square button
                  height: 150, // Height of the square button
                  margin: const EdgeInsets.all(10), // Space between buttons
                  child: ElevatedButton(
                    onPressed: _navigateToSignup, // Navigate to user signup
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40), // Icon inside the button
                        SizedBox(height: 8), // Space between icon and text
                        Text('User', style: TextStyle(fontSize: 16)), // Text inside the button
                      ],
                    ),
                  ),
                ),

                // "Guide" Button
                Container(
                  width: 150, // Width of the square button
                  height: 150, // Height of the square button
                  margin: const EdgeInsets.all(10), // Space between buttons
                  child: ElevatedButton(
                    onPressed: _navigateToguidesignup, // Navigate to guide signup
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 40), // Icon inside the button
                        SizedBox(height: 8), // Space between icon and text
                        Text('Guide', style: TextStyle(fontSize: 16)), // Text inside the button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
