import 'package:flutter/material.dart';

class GuideProfile extends StatefulWidget {
  final bool isEditing;

  const GuideProfile({super.key, required this.isEditing});

  @override
  State<GuideProfile> createState() => _GuideProfileState();
}

class _GuideProfileState extends State<GuideProfile> {
  late bool isEditing; 
  // Guide details
  String name = "John Doe";
  String phoneNumber = "123-456-7890";
  String email = "johndoe@example.com";
  String licenseNumber = "AB123456";
  String expertise = "Historical Tours, Adventure Trips";
  int experience = 10;
  double ratePerTrip = 150.0;
  String additionalDetails = "Fluent in English and Spanish. Specialized in eco-friendly tours.";
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
    isEditing = widget.isEditing; // Set isEditing from the widget

    nameController.text = name;
    phoneNumberController.text = phoneNumber;
    emailController.text = email;
    licenseNumberController.text = licenseNumber;
    expertiseController.text = expertise;
    experienceController.text = experience.toString();
    ratePerTripController.text = ratePerTrip.toString();
    additionalDetailsController.text = additionalDetails;
  }

  void saveChanges() {
    setState(() {
      name = nameController.text;
      phoneNumber = phoneNumberController.text;
      email = emailController.text;
      licenseNumber = licenseNumberController.text;
      expertise = expertiseController.text;
      experience = int.parse(experienceController.text);
      ratePerTrip = double.parse(ratePerTripController.text);
      additionalDetails = additionalDetailsController.text;
      isEditing = false;  // Set to false after saving
    });
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
            child: isEditing && isEditable
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
    return 
    SingleChildScrollView(
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
                  offset: const Offset(0, 3), // changes position of shadow
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
          if (isEditing)
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Save Changes"),
            ),
        ],
      ),
    );
  }
}