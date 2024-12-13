import 'package:flutter/material.dart';

class Guidedetails extends StatefulWidget {
  const Guidedetails({super.key, required String guidename});

  @override
  State<Guidedetails> createState() => _GuidedetailsState();
}

class _GuidedetailsState extends State<Guidedetails> {
  // Text controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(202, 19, 154, 216),
        title: const Text('Guide Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture (Icon for now, you can replace with image picker later)
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Implement image picker here for profile photo
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent,
                    backgroundImage: AssetImage('asset/background3.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Guide Name Text Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Guide Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Phone Number Text Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Email Address Text Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // License Number Text Field
              TextField(
                controller: _licenseController,
                decoration: const InputDecoration(
                  labelText: 'License Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Area of Expertise Text Field
              TextField(
                controller: _expertiseController,
                decoration: const InputDecoration(
                  labelText: 'Area of Expertise',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Years of Experience Text Field
              TextField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Per Trip Rate Text Field
              TextField(
                controller: _rateController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Per Trip Rate',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Save Profile Button
              ElevatedButton(
                onPressed: () {
                  // Implement save functionality here
                  String name = _nameController.text;
                  String phone = _phoneController.text;
                  String email = _emailController.text;
                  String license = _licenseController.text;
                  String expertise = _expertiseController.text;
                  String experience = _experienceController.text;
                  String rate = _rateController.text;

                  // Save the profile (e.g., to a database or local storage)
                  // You can replace this with actual logic to save the data
                  print("Profile Saved:");
                  print("Name: $name, Phone: $phone, Email: $email");
                  print("License: $license, Expertise: $expertise");
                  print("Experience: $experience, Rate: $rate");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
