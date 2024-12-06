import 'package:flutter/material.dart';
import 'package:travel_guide/select_user.dart'; // Ensure correct import path

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
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Only proceed if form is valid
      final email = _emailController.text;
      final password = _passwordController.text;
      print('Login successful with email: $email and password: $password');
    } else {
      // Show an error message if fields are empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
    }
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
      body: Stack(
        children: [
          SizedBox(height: 30),
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'asset/background3.jpg', // Ensure this path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Attach the form key to the Form widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Email field with validation
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
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

                  // Password field with validation
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
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
                    onPressed: _login, // Trigger login logic
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
        ],
      ),
    );
  }
}
