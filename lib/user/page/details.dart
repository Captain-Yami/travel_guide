import 'package:flutter/material.dart';
import 'package:travel_guide/user/page/login_page.dart';

class Details extends StatefulWidget {
  const Details({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key to the Form widget
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Details',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
              const SizedBox(height: 20),

              // Date of Birth Field with validation (DD/MM/YYYY)
              TextFormField(
                controller: DOB,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth (DD/MM/YYYY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date of Birth';
                  }
                  // Validate date format DD/MM/YYYY
                  RegExp dateRegEx = RegExp(r"^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$");
                  if (!dateRegEx.hasMatch(value)) {
                    return 'Please enter a valid date (DD/MM/YYYY)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Address Field with validation
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),

              // Pincode Field with validation (6 digits)
              TextFormField(
                controller: pincode,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  } else if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Pincode must be exactly 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // State Field with validation
              TextFormField(
                controller: state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),

              // City Field with validation
              TextFormField(
                controller: city,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),

              // Nation Field with validation
              TextFormField(
                controller: nation,
                decoration: const InputDecoration(
                  labelText: 'Nation',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),

              // Submit Button
              ElevatedButton(
                onPressed: registrationHandler, // Trigger form submission
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
