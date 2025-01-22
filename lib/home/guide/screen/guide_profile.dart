import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

class GuideProfile extends StatefulWidget {
  const GuideProfile({super.key, required this.isEditing});
  final bool isEditing;

  @override
  State<GuideProfile> createState() => _GuideProfileState();
}

class _GuideProfileState extends State<GuideProfile> {
  late bool isEditing;
  late String uid;

  // Profile image variables
  File? _profileImage;
  ImageProvider profileImage = const AssetImage('asset/background3.jpg'); // Default profile image

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

  // Cloudinary configuration
  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh',
    apiKey: '894239764992456',
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',
  );

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing;
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isNotEmpty) {
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

          // Initialize controllers with fetched data
          nameController.text = name;
          phoneNumberController.text = phoneNumber;
          emailController.text = email;
          licenseNumberController.text = licenseNumber;
          expertiseController.text = expertise;
          experienceController.text = experience.toString();
          ratePerTripController.text = ratePerTrip.toString();
          additionalDetailsController.text = additionalDetails;

          String profileImageUrl = data['profile_picture'] ?? '';
          profileImage = profileImageUrl.isEmpty
              ? const AssetImage('asset/background3.jpg') as ImageProvider
              : NetworkImage(profileImageUrl);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch guide details: $e')),
      );
    }
  }

  void saveChanges() async {
    String imageUrl = '';

    // Upload the profile image to Cloudinary if a new image is selected
    if (_profileImage != null) {
      imageUrl = await uploadImageToCloudinary(_profileImage!);
    }

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

      // Update Firestore with the updated details
      await FirebaseFirestore.instance.collection('Guide').doc(uid).update({
        'name': name,
        'phone number': phoneNumber,
        'gideemail': email,
        'License': licenseNumber,
        'expertise': expertise,
        'experience': experience,
        'ratePerTrip': ratePerTrip,
        'additionalDetails': additionalDetails,
        if (imageUrl.isNotEmpty) 'profile_picture': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    if (!isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enable edit mode to change the profile picture.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        profileImage = FileImage(_profileImage!);
      });
    }
  }

  Future<String> uploadImageToCloudinary(File imageFile) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        folder: 'profile_pictures/',
      );

      if (response.isSuccessful) {
        return response.secureUrl!;
      } else {
        throw Exception('Cloudinary upload failed: ${response.error}');
      }
    } catch (e) {
      throw Exception('Error uploading image to Cloudinary: $e');
    }
  }

  Widget buildProfileDetail(String label, String value,
      {bool isEditable = true, TextEditingController? controller}) {
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
                  onPressed: _pickProfileImage,
                  color: isEditing ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                  isEditing = true;
                });
              },
              child: const Text("Edit Profile"),
            ),
          if (isEditing)
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text("Save Changes"),
            ),
        ],
      ),
    );
  }
}