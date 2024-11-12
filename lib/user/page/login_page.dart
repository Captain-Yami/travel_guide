import 'package:flutter/material.dart';
import 'package:travel_guide/user/page/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to manage the input text
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  // Method to handle login action
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Only proceed if form is valid
      final username = _usernameController.text;
      final password = _passwordController.text;
      print('Login successful with username: $username and password: $password');
    } else {
      // Show an error message if fields are empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
    }
  }

  // Method to handle navigation to Signup page
  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key to the Form widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Username field with validation
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  } else if (value.length < 3) {
                    return 'Username must be at least 3 characters';
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
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
