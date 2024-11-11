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
  TextEditingController Emailaddress=TextEditingController();
  TextEditingController Phone_number=TextEditingController();
  TextEditingController confirmpassword=TextEditingController();
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
      ('Username: ${username.text}');
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
                  'asset/van.jpg', // Ensure this path is correct
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  
                ),
              ),
              const SizedBox(height:10),
              Text('Create Account',
              style: TextStyle(fontSize: 24,color: Colors.blue),),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: Emailaddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                )),
                const SizedBox(height:10),
              
              const SizedBox(height: 10),
              TextFormField(
                controller: Phone_number,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                )),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmpassword,
                obscureText: show,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                    setState(() {
                      show=!show;
                    });
                  }, icon: Icon(show? Icons.visibility:Icons.visibility_off),
                ),
              ),
              validator: (value){
                if(value==null || value.isEmpty){
                  return'please confirm your password';
                }else if (value!=password.text){
                  return 'password do not match';
                }
              },),
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
