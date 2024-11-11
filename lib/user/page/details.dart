import 'package:flutter/material.dart';
import 'package:travel_guide/user/page/signup.dart';
import 'package:travel_guide/user/page/login_page.dart';

class details extends StatefulWidget {
  const details({super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  TextEditingController DOB=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController nation=TextEditingController();
  TextEditingController pincode=TextEditingController();

final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    address.dispose();
    DOB.dispose();
    state.dispose();
    city.dispose();
    nation.dispose();
    pincode.dispose();
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
      // You could send the data to a backend or show a success message
    } else {
      // If the form is invalid, show a message or Snackbar
      print('Please correct the errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        const SizedBox(height:10),
              Text('Details',
              style: TextStyle(fontSize: 24,color: Colors.blue),),
              const SizedBox(height: 20),
              TextFormField(
                controller: DOB,
                decoration: const InputDecoration(
                  labelText: 'Date of birth',
                  border: OutlineInputBorder(),
                )
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                )
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: pincode,
                decoration: const InputDecoration(
                  labelText: 'pin code',
                  border: OutlineInputBorder(),
                )
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                )
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: city,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                )
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nation,
                decoration: const InputDecoration(
                  labelText: 'Nation',
                  border: OutlineInputBorder(),
                )
              ) , const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registrationHandler, // Handle form submission
                child: const Text('Sign Up'),
              ),      
       ]
      )
        
      )
    );
  }
}