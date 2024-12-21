import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/guide/userchat.dart';

class BookingDetailsPage extends StatefulWidget {
  final String name;
  final String image;
  final String requestId;
  final List<String> places;
  final Function(String) onRemoveBooking; // Callback to update parent widget

  const BookingDetailsPage({
    Key? key,
    required this.name,
    required this.image,
    required this.requestId,
    required this.places,
    required this.onRemoveBooking, // Ensure this is correctly passed
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isConfirmed = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final requestDoc = await _firestore
          .collection('confirmed_requests')
          .doc(widget.requestId)
          .get();

      if (requestDoc.exists) {
        final userId = requestDoc.data()?['user'];
        final status = requestDoc.data()?['status'];
        if (userId != null && status == 'Confirmed') {
          final userDoc = await _firestore.collection('Users').doc(userId).get();
          if (userDoc.exists) {
            setState(() {
              userData = userDoc.data();
              isLoading = false;
              isConfirmed = true;
            });
          }
        } else {
          setState(() {
            isLoading = false;
            isConfirmed = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _cancelBooking(String requestId) async {
    try {
      // Delete the booking from Firestore
      await _firestore.collection('confirmed_requests').doc(requestId).delete();

      // Call the callback to update the parent widget
      widget.onRemoveBooking(requestId);

      // Immediately update the UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking canceled successfully!')),
        );

        Navigator.pop(context); // Navigate back to the previous screen
      }
    } catch (e) {
      print('Error canceling booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel booking.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isConfirmed) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Details', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black87,
        ),
        body: const Center(
          child: Text('This booking is not confirmed.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${userData!['name']}\'s Booking Details', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(userData!['profileImage'] ?? ''),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData!['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Status: Confirmed',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 11, 11, 11)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Places Section
            const Text(
              'Places to visit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.places.map((place) => Text(place)).toList(),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _cancelBooking(widget.requestId),
                  child: const Text('Cancel Booking', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 30,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChat(
                          name: userData!['name'] ?? 'Unknown',
                          profilePic: userData!['profileImage'] ?? '',
                          lastMessage: 'Looking forward to our trip!',
                          messageTime: 'Yesterday',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat with User', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
