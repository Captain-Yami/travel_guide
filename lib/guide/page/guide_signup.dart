import 'package:flutter/material.dart';
import 'package:travel_guide/guide/page/guide_details.dart';
import 'package:travel_guide/user/page/details.dart';
import 'package:travel_guide/user/page/login_page.dart';

class GuideSignup extends StatefulWidget {
  const GuideSignup({super.key});

  @override
  State<GuideSignup> createState() => _GuideSignupState();
}

class _GuideSignupState extends State<GuideSignup> {
  // TextEditingControllers for username, email, phone, password, and confirm password
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Emailaddress = TextEditingController();
  TextEditingController Phone_number = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  bool show = true;

  // Create a GlobalKey to manage the form state
  final _formKey = GlobalKey<FormState>();

  // Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    Emailaddress.dispose();
    Phone_number.dispose();
    confirmpassword.dispose();
    super.dispose();
  }

  // Handle the registration logic (form submission)
  void registrationHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, you can handle the registration logic
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GuideDetails();
      }));
      print('Registration Successful');
      print('Username: ${username.text}');
      print('Password: ${password.text}');
      // You could send the data to a backend or show a success message
    } else {
      // If the form is invalid, show a message or Snackbar
      print('Please correct the errors');
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,  // Attach the form key here
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'asset/logo3.jpg', // Ensure this path is correct
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
                const SizedBox(height: 20),
        
                // Username field
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
        
                // Email field with validation
                TextFormField(
                  controller: Emailaddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
        
                // Phone number field with validation
                TextFormField(
                  controller: Phone_number,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length < 10) {
                      return 'Phone number should be at least 10 digits';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Phone number can only contain digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
        
                // Password field with validation
                TextFormField(
                  controller: password,
                  obscureText: show,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
        
                // Confirm password field with validation
                TextFormField(
                  controller: confirmpassword,
                  obscureText: show,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
        
                // Sign Up Button
                ElevatedButton(
                  onPressed: registrationHandler,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
