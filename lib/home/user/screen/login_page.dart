import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:travel_guide/home/user/home_page.dart'; // Ensure correct import path
import 'package:travel_guide/home/user/service/userfirebaseauthservice.dart'; // Ensure correct import path
import 'package:travel_guide/select_user.dart';
import 'package:travel_guide/services/login_services.dart'; // Ensure correct import path

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to manage the input text
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  // Method to handle login action
  bool loading = false;

  void LoginHandler() async {
    setState(() {
      loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Call the login function
    await LoginServiceFire().LoginService(
      email: email,
      password: password,
      context: context,
    );
    setState(() {
      loading = false;
    });
  }

  // Method to handle navigation to Signup page
  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black color for AppBar
        foregroundColor: Colors.white, // White color for text in AppBar
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: SingleChildScrollView(  // Make the entire form scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Attach the form key to the Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Add the text at the top center
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 30, // Set font size
                    color: Colors.black, // Set text color
                    fontWeight: FontWeight.bold, // Bold text style
                  ),
                  textAlign: TextAlign.center, // Center align the text
                ),
                SizedBox(height: 100), // Add some spacing

                // Email field with validation and oval shape
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Oval shape
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),

                // Password field with validation and oval shape
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Oval shape
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                      // Password should contain at least one lowercase, one uppercase, and one digit
                      return 'Password must include at least one uppercase letter, one lowercase letter, and one number';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),

                // Login button
                ElevatedButton(
                  onPressed: LoginHandler, // Trigger login logic
                  child: Text('Login'),
                ),
                SizedBox(height: 10),

                // Redirect to Signup page
                TextButton(
                  onPressed: _navigateToSignup, // Navigate to Signup page
                  child: Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, // Increased font size for better readability
                      color: const Color(0xFF123E03),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
