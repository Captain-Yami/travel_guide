import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/screen/req.dart';
import 'package:travel_guide/home/guide/userchat.dart';

class RequestDetailsPage extends StatelessWidget {
  final String requestId;
  final String name;
  final String image;
  final List<String> placesToVisit;
  final List<String> interestedCategories;
  final String details;
  final String user;

  RequestDetailsPage({
    Key? key,
    required this.requestId,
    required this.name,
    required this.image,
    required this.placesToVisit,
    required this.interestedCategories,
    required this.details,
    required this.user,
  }) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleterequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).delete();
    } catch (e) {
      debugPrint('Error deleting request: $e');
    }
  }

  Future<void> handleConfirmation(BuildContext context) async {
    try {
      String placesStr = placesToVisit.join(', ');
      String aboutTripStr = details;
      String expertiseStr = interestedCategories.join(', ');

      final confirmedRequestDetails = {
        'userName': name,
        'image': image,
        'places': placesStr,
        'aboutTrip': aboutTripStr,
        'expertise': expertiseStr,
        'status': 'Confirmed',
        'requestDate': FieldValue.serverTimestamp(),
        'user': user,
      };

      await _firestore
          .collection('confirmed_requests')
          .doc(requestId)
          .set(confirmedRequestDetails);

      await _firestore
          .collection('requests')
          .doc(requestId)
          .update({'status': 'Confirmed'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request for $name has been confirmed!')),
      );

      await deleterequest(requestId);

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error confirming request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm request.')),
      );
    }
  }

  Future<void> handleDecline(BuildContext context) async {
    try {
      await _firestore
          .collection('requests')
          .doc(requestId)
          .update({'status': 'Declined'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request from $name has been declined.')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error declining request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline request.')),
      );
    }
  }

  void showDeleteConfirmationDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm decline'),
          content: const Text('Are you sure you want to decline this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleterequest(requestId); // Delete user if confirmed
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$name\'s Request Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage(image), // Use NetworkImage if applicable
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.error), // Fallback for invalid images
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Status: Pending',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 10, 10, 10)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(details),
            const SizedBox(height: 16),
            const Text(
              'Interested Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(interestedCategories.join(', ')),
            const SizedBox(height: 16),
            const Text(
              'Places to Visit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(placesToVisit.join(', ')),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleConfirmation(context),
                  child: const Text('Confirm',
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      showDeleteConfirmationDialog(context, requestId),
                  child: const Text('Decline',
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
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
