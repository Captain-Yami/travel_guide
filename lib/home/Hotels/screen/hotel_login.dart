import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_registration.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_homepage.dart'; // Import the HotelHomepage

class HotelLoginPage extends StatefulWidget {
  const HotelLoginPage({super.key});

  @override
  State<HotelLoginPage> createState() => _HotelLoginPageState();
}

class _HotelLoginPageState extends State<HotelLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HotelHomepage()),
      );
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Query the Firestore collection 'hotels' where the email matches
      var snapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      // Check if the document exists and isApproved is true
      if (snapshot.docs.isNotEmpty) {
        var userDoc = snapshot.docs.first;
        if (userDoc['isApproved'] == true) {
          // Proceed with the successful login
          setState(() {
            _isLoading = false;
          });

          // Redirect to HotelHomepage upon successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HotelHomepage()), // Navigate to the HotelHomepage
          );

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login Successful")));
        } else {
          // Show an error message if user is not approved
          setState(() {
            _errorMessage = 'Your account is not approved yet';
            _isLoading = false;
          });
        }
      } else {
        // Show an error if no matching email/password found
        setState(() {
          _errorMessage = 'Invalid email or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              // "Do you have an account?" and Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do you have an account?'),
                  TextButton(
                    onPressed: () {
                      // Navigate to the HotelRegistrationPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HotelRegistrationPage()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
