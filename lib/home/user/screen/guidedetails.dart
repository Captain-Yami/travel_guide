import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Guide {
  final String name;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final String expertise;
  final String experience;
  final String ratePerTrip;
  final String details;
  final String profileImage;

  Guide({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    required this.expertise,
    required this.experience,
    required this.ratePerTrip,
    required this.details,
    required this.profileImage,
  });

  // Factory constructor to handle Firestore data
  factory Guide.fromFirestore(Map<String, dynamic> data) {
    return Guide(
      name: data['name']?.toString() ?? '',
      phoneNumber: data['phone number']?.toString() ?? '',
      email: data['gideemail']?.toString() ?? '',
      licenseNumber: data['License']?.toString() ?? '',
      expertise: data['expertise']?.toString() ?? '',
      experience: data['experience']?.toString() ?? '',
      ratePerTrip: data['ratePerTrip']?.toString() ?? '',
      details: data['additionalDetails']?.toString() ?? '',
      profileImage: data['licenseImageUrl']?.toString() ?? '',
    );
  }
}

class Guidedetails extends StatefulWidget {
  const Guidedetails({super.key});

  @override
  State<Guidedetails> createState() => _GuidedetailsState();
}

class _GuidedetailsState extends State<Guidedetails> {
  List<Guide> guides = [];

  @override
  void initState() {
    super.initState();
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Guide')
          .get();

      List<Guide> fetchedGuides = querySnapshot.docs.map((doc) {
        var data = doc.data();
        print('Guide Data: $data');  // Debugging line
        return Guide.fromFirestore(data);
      }).toList();

      setState(() {
        guides = fetchedGuides;
      });
    } catch (e) {
      print('Error fetching guides: $e');
    }
  }

  void _navigateToGuideDetails(Guide guide) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuideDetailPage(guide: guide),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Guides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: guides.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No guides available at the moment.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () => _navigateToGuideDetails(guide),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(guide.profileImage),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                guide.expertise,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.black),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class GuideDetailPage extends StatelessWidget {
  final Guide guide;

  const GuideDetailPage({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          guide.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(guide.profileImage),
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Name', guide.name),
                _buildDetailRow('Phone Number', guide.phoneNumber),
                _buildDetailRow('Email', guide.email),
                _buildDetailRow('License Number', guide.licenseNumber),
                _buildDetailRow('Expertise', guide.expertise),
                _buildDetailRow('Experience', guide.experience),
                _buildDetailRow('Rate Per Trip', guide.ratePerTrip),
                const SizedBox(height: 10),
                const Text(
                  'Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  guide.details,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20), // Add spacing before buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Request" Button (aligned to the left)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the request action here
                          print('Request button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Request Guide'),
                      ),
                    ),
                    const SizedBox(width: 10), // Add some space between buttons
                    // "Chat with Guide" Button (aligned to the right)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the chat action here
                          print('Chat with Guide button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Chat with Guide'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
