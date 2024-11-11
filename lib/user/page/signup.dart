import 'package:flutter/material.dart';
import 'package:travel_guide/user/page/login_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // TextEditingControllers for username and password
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool show = true;

  // Create a GlobalKey to manage the form state
  final _formKey = GlobalKey<FormState>();

  // Dispose controllers to avoid memory leaks
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  // Handle the registration logic (form submission)
  void registrationHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, you can handle the registration logic
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      },));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Attach the form key here
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'asset/download.jpg', // Ensure this path is correct
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                // Validation for username
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                // Validation for password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registrationHandler, // Handle form submission
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
