import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/screen/guide_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';
import 'package:travel_guide/home/guide/service/guidefirebaseauthservice.dart';

class GuideSignup extends StatefulWidget {
  const GuideSignup({super.key});

  @override
  State<GuideSignup> createState() => _GuideSignupState();
}

class _GuideSignupState extends State<GuideSignup> {
  // TextEditingControllers for username, email, phone, password, confirm password, and Aadhar number
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Emailaddress = TextEditingController();
  TextEditingController Phone_number = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();
  bool show = true;

  // Store selected file name (for demonstration purposes)

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
    aadharNumber.dispose();
    super.dispose();
  }

  // Handle the registration logic (form submission)
  void registrationHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, navigate to the next screen
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GuideDetails(guideName: '',);  // Navigate to GuideDetails screen
      }));
      print('Registration Successful');
      print('Username: ${username.text}');
      print('Password: ${password.text}');
    } else {
      // If the form is invalid, show a message or Snackbar
      print('Please correct the errors');
    }
  }

  // Function to simulate file selection (In a real app, you would use a file picker package)
Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {});
    }
  }
  void Registerguide() {
    if (_formKey.currentState?.validate() ?? false) {
      Guidefirebaseauthservice().guideRegister(
                    email:Emailaddress.text,
                    username: username.text,
                    Phone_number:Phone_number.text,
                    password:password.text,
                    aadhar:aadharNumber.text,
                    context: context,
                  );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const GuideHomepage();
          },
        ),
      ); // Add further sign-up logic here, like calling an API
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Black color for AppBar
        elevation: 0, // No elevation to keep it flat
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Attach the form key here
          child: Column(
            children: [
              // Circular logo image
              ClipOval(
                child: Image.asset(
                  'asset/logo3.jpg',  // Ensure this path is correct
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
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
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

              // Email field with oval shape and validation
              TextFormField(
                controller: Emailaddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
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

              // Phone number field with oval shape and validation
              TextFormField(
                controller: Phone_number,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
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

              // Password field with oval shape and validation
              TextFormField(
                controller: password,
                obscureText: show,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
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
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Confirm password field with oval shape and validation
              TextFormField(
                controller: confirmpassword,
                obscureText: show,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
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
              const SizedBox(height: 10),

              // Aadhar number field with oval shape and validation
              TextFormField(
                controller: aadharNumber,
                decoration: InputDecoration(
                  labelText: 'Aadhar Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Oval border
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Aadhar number';
                  } else if (value.length != 12) {
                    return 'Aadhar number should be 12 digits';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Aadhar number can only contain digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Upload File Button
              ElevatedButton(
                    onPressed: _pickDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 60.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                       foregroundColor: Colors.black, // Text color set to black
                    ),
                    child: const Text('Upload License'),
                  ),
                  const SizedBox(height: 20),
                   ElevatedButton(
               onPressed:Registerguide,  // Trigger form submission
                 style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                       foregroundColor: Colors.black, // Text color set to black
                    ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
