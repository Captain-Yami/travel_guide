import 'package:flutter/material.dart';
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

  void _navigateToguidesignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuideSignup()),
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

            // Row to place the buttons to the left and right
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align buttons to center
              children: <Widget>[
                // "User" Button on the left
                Container(
                  width: 150, // Width of the square button
                  height: 150, // Height of the square button
                  margin: const EdgeInsets.symmetric(horizontal: 20), // Reduced horizontal margin between buttons
                  child: ElevatedButton(
                    onPressed: _navigateToSignup, // Navigate to user signup
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240), // Set button color to light grey
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 40, color: Colors.black), // Icon inside the button
                        SizedBox(height: 8), // Space between icon and text
                        Text('User', style: TextStyle(fontSize: 16, color: Colors.black)), // Text inside the button
                      ],
                    ),
                  ),
                ),

                // "Guide" Button on the right
                Container(
                  width: 150, // Width of the square button
                  height: 150, // Height of the square button
                  margin: const EdgeInsets.symmetric(horizontal: 20), // Reduced horizontal margin between buttons
                  child: ElevatedButton(
                    onPressed: _navigateToguidesignup, // Navigate to guide signup
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240), // Set button color to light grey
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 40, color: Colors.black), // Icon inside the button
                        SizedBox(height: 8), // Space between icon and text
                        Text('Guide', style: TextStyle(fontSize: 16, color: Colors.black)), // Text inside the button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
