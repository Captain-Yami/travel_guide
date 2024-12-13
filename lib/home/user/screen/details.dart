import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';
import 'package:travel_guide/home/user/service/userfirebaseauthservice.dart';

class Details extends StatefulWidget {
  const Details({super.key, required this.username, required this.EmailAddress, required this.Phone_number, required this.password});

  final String username;
  final String EmailAddress;
  final String Phone_number;
  final String password;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // TextEditingControllers for each field
  TextEditingController DOB = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController nation = TextEditingController();
  TextEditingController pincode = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    address.dispose();
    DOB.dispose();
    state.dispose();
    city.dispose();
    nation.dispose();
    pincode.dispose();
    super.dispose();
  }

  // Handle form submission
  void registrationHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, navigate to LoginPage
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
      print('Registration Successful');
    } else {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key to the Form widget
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Details',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Date of Birth Field with validation (DD/MM/YYYY)
              TextFormField(
                controller: DOB,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth (DD/MM/YYYY)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date of Birth';
                  }
                  // Validate date format DD/MM/YYYY
                  RegExp dateRegEx = RegExp(
                      r"^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$");
                  if (!dateRegEx.hasMatch(value)) {
                    return 'Please enter a valid date (DD/MM/YYYY)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Address Field with validation and oval shape
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  // Allow only alphabetic characters and spaces
                  RegExp addressRegEx = RegExp(r"^[a-zA-Z0-9\s,.'-]{3,}$");
                  if (!addressRegEx.hasMatch(value)) {
                    return 'Please enter a valid address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pincode Field with validation (6 digits) and oval shape
              TextFormField(
                controller: pincode,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  } else if (value.length != 6 ||
                      !RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Pincode must be exactly 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // State Field with validation and oval shape
              TextFormField(
                controller: state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  // Allow only alphabetic characters
                  RegExp stateRegEx = RegExp(r"^[a-zA-Z\s]+$");
                  if (!stateRegEx.hasMatch(value)) {
                    return 'State name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // City Field with validation and oval shape
              TextFormField(
                controller: city,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  // Allow only alphabetic characters
                  RegExp cityRegEx = RegExp(r"^[a-zA-Z\s]+$");
                  if (!cityRegEx.hasMatch(value)) {
                    return 'City name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nation Field with validation and oval shape
              TextFormField(
                controller: nation,
                decoration: const InputDecoration(
                  labelText: 'Nation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nation';
                  }
                  // Allow only alphabetic characters
                  RegExp nationRegEx = RegExp(r"^[a-zA-Z\s]+$");
                  if (!nationRegEx.hasMatch(value)) {
                    return 'Nation name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  Userfirebaseauthservice().UserRegister(
                    email: widget.EmailAddress,
                    username: widget.username,
                    Phone_number: widget.Phone_number,
                    password: widget.password,
                    DOB: DOB.text,
                    address: address.text,
                    pincode: pincode.text,
                    state: state.text,
                    city: city.text,
                    nation: nation.text,
                    context: context,
                  );
                }, // Trigger form submission
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
