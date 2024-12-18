import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';


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

  // To track whether the fields should be editable or not
  bool isEditable = false;

  // To store the profile image file
  File? _profileImage;

  // Cloudinary configuration
  final Cloudinary cloudinary = Cloudinary.signedConfig ( cloudName: 'db2nki9dh',
  apiKey: '894239764992456', 
  apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',);

  // Function to save the profile data to Firestore
  Future<void> saveProfile() async {
    try {
      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String imageUrl = '';

      // If the user uploaded a new profile image, upload it to Cloudinary
      if (_profileImage != null) {
        imageUrl = await uploadImageToCloudinary(_profileImage!); // Upload to Cloudinary
      }

      // Update the Firestore document with the new data
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'name': usernameController.text,
        'useremail': emailController.text,
        'phone_number': phoneController.text,
        'DOB': dobController.text,
        'address': addressController.text,
        'city': cityController.text,
        'state': stateController.text,
        'nation': nationController.text,
        'pincode': pincodeController.text,
        if (imageUrl.isNotEmpty) 'profile_picture': imageUrl,  // Add profile image URL if available
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      // After saving, toggle back to non-editable state
      setState(() {
        isEditable = false;
      });
    } catch (e) {
      // Handle any errors that occur during the save process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to pick the profile image
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Cloudinary
  Future<String> uploadImageToCloudinary(File imageFile) async {
    try {
      // Upload the image to Cloudinary
      final response = await cloudinary.upload(
        file: imageFile.path,
        folder: 'profile_pictures/', // Optional: You can specify a folder
      );

      // Return the URL of the uploaded image
      if (response.isSuccessful) {
        return response.secureUrl!;
      } else {
        throw Exception('Cloudinary upload failed: ${response.error}');
      }
    } catch (e) {
      throw Exception('Error uploading image to Cloudinary: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 254), // App bar with black color
        title: const Text('Profile'),
        actions: [
          // Dropdown menu button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color.fromARGB(255, 0, 0, 0)),
            onSelected: (String value) {
              if (value == 'Feedback') {
                // Handle feedback action
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Feedback'),
                    content: TextField(
                      decoration: const InputDecoration(hintText: 'Enter your feedback'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Submit feedback logic here
                          Navigator.of(context).pop();
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                );
              } else if (value == 'Logout') {
                // Handle logout action
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
                  );
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Feedback',
                  child: Row(
                    children: const [
                      Icon(Icons.feedback),
                      SizedBox(width: 8),
                      Text('Feedback'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Logout',
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available.'));
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

          // Load the profile image if available
          String profileImageUrl = profileData['profile_picture'] ?? '';
          ImageProvider profileImage = profileImageUrl.isEmpty
              ? const AssetImage('asset/background3.jpg') as ImageProvider
              : NetworkImage(profileImageUrl);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Profile picture section - Centered
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: profileImage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickProfileImage, // Allow user to pick an image
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Full Name field (streamed data)
                TextField(
                  controller: usernameController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                // Email field (streamed data)
                TextField(
                  controller: emailController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                // Phone Number field (streamed data)
                TextField(
                  controller: phoneController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 10),
                // Date of Birth field (streamed data)
                TextField(
                  controller: dobController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                // Address field (streamed data)
                TextField(
                  controller: addressController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 10),
                // City field (streamed data)
                TextField(
                  controller: cityController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 10),
                // State field (streamed data)
                TextField(
                  controller: stateController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 10),
                // Nation field (streamed data)
                TextField(
                  controller: nationController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Nation',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 10),
                // Pincode field (streamed data)
                TextField(
                  controller: pincodeController,
                  enabled: isEditable, // Toggle editing
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.pin_drop),
                  ),
                ), 
                const SizedBox(height: 20),
                // Edit Profile Button
                ElevatedButton(
                  onPressed: () {
                    if (isEditable) {
                      saveProfile(); // Save the profile if in edit mode
                    } else {
                      setState(() {
                        // Toggle the editable state
                        isEditable = !isEditable;
                      });
                    }
                  },
                  child: Text(isEditable ? 'Save Profile' : 'Edit Profile'), // Button text changes
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
