import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/guide/userchat.dart';

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
  final String id;
  final bool isAvailable; // New field for availability

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
    required this.id,
    required this.isAvailable,
  });

  // Factory constructor to handle Firestore data
  factory Guide.fromFirestore(
      Map<String, dynamic> data, String id, bool isAvailable) {
    return Guide(
      name: data['name']?.toString() ?? '',
      phoneNumber: data['phone number']?.toString() ?? '',
      email: data['gideemail']?.toString() ?? '',
      licenseNumber: data['License']?.toString() ?? '',
      expertise: data['expertise']?.toString() ?? '',
      experience: data['experience']?.toString() ?? '',
      ratePerTrip: data['ratePerTrip']?.toString() ?? '',
      details: data['additionalDetails']?.toString() ?? '',
      profileImage: data['profile_picture']?.toString() ?? '',
      id: id,
      isAvailable: isAvailable, // Include availability status
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
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Guide').get();

      List<Guide> fetchedGuides = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();

        // Fetch availability details for each guide
        var availabilitySnapshot = await FirebaseFirestore.instance
            .collection('Guide')
            .doc(doc.id)
            .collection('availability')
            .doc('data')
            .get();

        if (availabilitySnapshot.exists) {
          var availabilityData = availabilitySnapshot.data()!;
          bool isSelected = availabilityData['isSelected'] ?? false;

          // Debug: Log availability data
          print('Guide ID: ${doc.id}');
          print('Availability Data: $availabilityData');

          if (isSelected) {
            // Check if the guide is available today
            final dayOfWeek = DateTime.now().weekday - 1; // Monday = 0
            final today =
                availabilityData['selectedDays'] as List<dynamic>? ?? [];

            // Debug: Log day comparison
            print('Today: ${[
              'sunday',
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday'
            ][dayOfWeek]}');
            print('Selected Days: $today');

            if (today.contains([
              'sunday',
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday'
            ][dayOfWeek])) {
              // Check time interval
              final now = TimeOfDay.now();
              final startTime = TimeOfDay(
                hour: availabilityData['startTime']['hour'],
                minute: availabilityData['startTime']['minute'],
              );
              final endTime = TimeOfDay(
                hour: availabilityData['endTime']['hour'],
                minute: availabilityData['endTime']['minute'],
              );

              // Debug: Log time comparison
              print('Now: $now');
              print('Start Time: $startTime, End Time: $endTime');

              if (_isTimeWithinRange(now, startTime, endTime)) {
                fetchedGuides.add(Guide.fromFirestore(data, doc.id, true));
              } else {
                print(
                    'Guide ${doc.id} is not available within the time range.');
              }
            } else {
              print('Guide ${doc.id} is not available today.');
            }
          } else {
            print('Guide ${doc.id} is not selected for availability.');
          }
        } else {
          print('No availability data for Guide ${doc.id}.');
        }
      }

      setState(() {
        guides = fetchedGuides;
      });

      // Debug: Log fetched guides
      print('Fetched Guides: ${guides.length}');
    } catch (e) {
      print('Error fetching guides: $e');
    }
  }

  // Helper function to check if current time is within the start and end time
  bool _isTimeWithinRange(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
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
                  'No available guides at the moment.',
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
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.black),
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
  // Add this method to fetch the current user's details
  Future<Map<String, String?>> _fetchUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in.');
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    final userName = userDoc.data()?['name'] ?? 'Unknown User';
    final userProfilePic = userDoc.data()?['profile_picture'] ?? 'asset/background3.jpg';

    return {'userId': userId, 'userName': userName, 'userProfilePic': userProfilePic};
  }

  void _startChat(BuildContext context, String userId, String guideId,
      String userName, String guideName, String userProfilePic, String profileImage) {
    if (userId.isEmpty || userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data.')),
      );
      return;
    }

    // Create a unique chat ID based on the user ID and guide ID
    final chatId =
        userId.compareTo(guideId) < 0 ? '$userId-$guideId' : '$guideId-$userId';

    // Navigate to the chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId,
          guideId: guideId,
          userId: userId,
          userName: userName,
          guideName: guideName,
          userProfilePic: userProfilePic, 
          guideProfilePic: profileImage,
        ),
      ),
    );
  }

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
                          // Show a dialog when clicking "Request Guide"
                          _showRequestDialog(context);
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
                        onPressed: () async {
                          try {
                            final userDetails = await _fetchUserDetails();
                            final userId = userDetails['userId']!;
                            final userName = userDetails['userName']!;
                            final userProfilePic = userDetails['userProfilePic']!;

                            // Start the chat with the guide using fetched details
                            _startChat(
                              context, // Pass the context
                              userId, // Pass the user ID
                              guide.id, // Pass the guide ID
                              userName, // Pass the current user's name
                              guide.name, // Pass the guide's name
                              userProfilePic,
                              guide.profileImage,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to fetch user details.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 240),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black54),
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

  void _showRequestDialog(BuildContext context) {
    final TextEditingController tripController = TextEditingController();
    final TextEditingController categoriesController = TextEditingController();
    final TextEditingController placesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Request Guide'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tripController,
                  decoration: const InputDecoration(labelText: 'About Trip'),
                  maxLines: 3,
                ),
                TextField(
                  controller: categoriesController,
                  decoration: const InputDecoration(
                      labelText: 'Interested Categories (Expertise)'),
                  maxLines: 2,
                ),
                TextField(
                  controller: placesController,
                  decoration:
                      const InputDecoration(labelText: 'Places to Visit'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Fetch the current user's ID
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in.')),
                    );
                    return;
                  }

                  // Fetch the user's name from Firestore
                  final userDoc = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .get();

                  final userName = userDoc.data()?['name'] ?? 'Unknown User';
                  final userProfilePic = userDoc.data()?['profile_picture'] ?? 'asset/background3.jpg';

                  // Send the request to Firestore with the user's name and guideId
                  await FirebaseFirestore.instance.collection('requests').add({
                    'userProfilePic':userProfilePic,
                    'guideId': guide.id, // Add guideId to the request
                    'aboutTrip': tripController.text,
                    'categories': categoriesController.text,
                    'places': placesController.text,
                    'user': userId,
                    'userName': userName, // Add the user's name
                    'requestDate': Timestamp.now(),
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request sent successfully!')),
                  );
                } catch (e) {
                  print('Error sending request: $e');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to send request.')),
                  );
                }
              },
              child: const Text('Send Request'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
