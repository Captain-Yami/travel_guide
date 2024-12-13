import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/details.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
        return Details(username: username.text, password: password.text, EmailAddress: Emailaddress.text, Phone_number: Phone_number.text);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black color for AppBar
        elevation: 0, // Remove shadow for a clean look
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,  // Attach the form key here
            child: Column(
              children: [
                // Circular Logo Image
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
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 20),
    
                // Username field with oval shape
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
    
                // Email field with validation and oval shape
                TextFormField(
                  controller: Emailaddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                    ),
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
    
                // Phone number field with validation and oval shape
                TextFormField(
                  controller: Phone_number,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                    ),
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
    
                // Password field with validation and oval shape
                TextFormField(
                  controller: password,
                  obscureText: show,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                    ),
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
                    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(value)) {
                      return 'Password must include at least one uppercase letter, one lowercase letter, and one number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
    
                // Confirm password field with validation and oval shape
                TextFormField(
                  controller: confirmpassword,
                  obscureText: show,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                    ),
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
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
