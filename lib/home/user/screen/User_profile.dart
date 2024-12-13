import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Controllers for the text fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController nationController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No profile data available.'));
          }

          // Get user profile data from snapshot
          var profileData = snapshot.data?.data() as Map<String, dynamic>;

          // Populate text field controllers with the profile data
          usernameController.text = profileData['name'] ?? '';
          emailController.text = profileData['useremail'] ?? '';
          phoneController.text = profileData['phone_number'] ?? '';
          dobController.text = profileData['DOB'] ?? '';
          addressController.text = profileData['address'] ?? '';
          cityController.text = profileData['city'] ?? '';
          stateController.text = profileData['state'] ?? '';
          nationController.text = profileData['nation'] ?? '';
          pincodeController.text = profileData['pincode'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
            
              children: [
                // Profile picture section
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: AssetImage('asset/background3.jpg') as ImageProvider,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Full Name field (streamed data)
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                // Email field (streamed data)
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                // Phone Number field (streamed data)
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 10),
                // Date of Birth field (streamed data)
                TextField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                // Address field (streamed data)
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 10),
                // City field (streamed data)
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 10),
                // State field (streamed data)
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 10),
                // Nation field (streamed data)
                TextField(
                  controller: nationController,
                  decoration: InputDecoration(
                    labelText: 'Nation',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 10),
                // Pincode field (streamed data)
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.pin_drop),
                  ),
                ),
                const SizedBox(height: 20),
                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // You can handle saving the profile information here
                    // For example, you can send updated data back to Firestore
                  },
                  child: const Text('Save Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
