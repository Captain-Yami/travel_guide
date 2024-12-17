import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuideProfile extends StatefulWidget {
  const GuideProfile({super.key, required bool isEditing});

  @override
  State<GuideProfile> createState() => _GuideProfileState();
}

class _GuideProfileState extends State<GuideProfile> {
  late bool isEditing;
  late String uid;

  // Guide details
  String name = "";
  String phoneNumber = "";
  String email = "";
  String licenseNumber = "";
  String expertise = "";
  int experience = 0;
  double ratePerTrip = 0.0;
  String additionalDetails = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController ratePerTripController = TextEditingController();
  final TextEditingController additionalDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEditing = false;  // Start in view mode by default

    // Get the current user's UID
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isNotEmpty) {
      // Fetch the user's guide details from Firestore
      _fetchGuideDetails();
    }
  }

  Future<void> _fetchGuideDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('Guide').doc(uid).get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data()!;
        setState(() {
          name = data['name'] ?? '';
          phoneNumber = data['phone number'] ?? '';
          email = data['gideemail'] ?? '';
          licenseNumber = data['License'] ?? '';
          expertise = data['expertise'] ?? '';
          experience = data['experience'] ?? 0;
          ratePerTrip = data['ratePerTrip'] ?? 0.0;
          additionalDetails = data['additionalDetails'] ?? '';

          // Initialize controllers with the fetched data
          nameController.text = name;
          phoneNumberController.text = phoneNumber;
          emailController.text = email;
          licenseNumberController.text = licenseNumber;
          expertiseController.text = expertise;
          experienceController.text = experience.toString();
          ratePerTripController.text = ratePerTrip.toString();
          additionalDetailsController.text = additionalDetails;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch guide details: $e')));
    }
  }

  void saveChanges() async {
    try {
      setState(() {
        name = nameController.text;
        phoneNumber = phoneNumberController.text;
        email = emailController.text;
        licenseNumber = licenseNumberController.text;
        expertise = expertiseController.text;
        experience = int.parse(experienceController.text);
        ratePerTrip = double.parse(ratePerTripController.text);
        additionalDetails = additionalDetailsController.text;
        isEditing = false;
      });

      // Update the guide details in Firestore
      await FirebaseFirestore.instance.collection('Guide').doc(uid).update({
        'name': name,
        'phone number': phoneNumber,
        'gideemail': email,
        'License': licenseNumber,
        'expertise': expertise,
        'experience': experience,
        'ratePerTrip': ratePerTrip,
        'additionalDetails': additionalDetails,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    }
  }

  Widget buildProfileDetail(String label, String value, {bool isEditable = true, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: isEditing
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('asset/background3.jpg'), // Replace with your asset path
          ),
          const SizedBox(height: 20),

          // Profile Details Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildProfileDetail("Name", name, controller: nameController),
                buildProfileDetail("Phone Number", phoneNumber, controller: phoneNumberController),
                buildProfileDetail("Email", email, controller: emailController),
                buildProfileDetail("License Number", licenseNumber, controller: licenseNumberController),
                buildProfileDetail("Expertise", expertise, controller: expertiseController),
                buildProfileDetail("Years of Experience", experience.toString(), controller: experienceController),
                buildProfileDetail("Per Trip Rate", "\$${ratePerTrip.toStringAsFixed(2)}", controller: ratePerTripController),
                buildProfileDetail("Additional Details", additionalDetails, controller: additionalDetailsController),
              ],
            ),
          ),

          const SizedBox(height: 20),
          if (!isEditing)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = true; // Switch to edit mode
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                textStyle: const TextStyle(fontSize: 16),
                foregroundColor: Colors.black,
              ),
              child: const Text("Edit Profile"),
            ),
          if (isEditing)
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                textStyle: const TextStyle(fontSize: 16),
                foregroundColor: Colors.black,
              ),
              child: const Text("Save Changes"),
            ),
        ],
      ),
    );
  }
}
