import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/userchat.dart';

class RequestDetailsPage extends StatelessWidget {
  final String requestId;
  final String name;
  final String image;
  final List<String> placesToVisit;
  final List<String> interestedCategories;
  final String details;

  const RequestDetailsPage({
    required this.requestId,
    required this.name,
    required this.image,
    required this.placesToVisit,
    required this.interestedCategories,
    required this.details, required Function() onConfirm, required Function() onDecline,
  });

  Future<void> handleConfirmation(BuildContext context) async {
  try {
    // Concatenate the details into a single string
    String placesStr = placesToVisit.join(', ');  // Concatenate places as a string
    String aboutTripStr = details;  // Use details as a single string for the aboutTrip
    String expertiseStr = interestedCategories.join(', ');  // Concatenate expertise as a string

    // Create a map with the concatenated string values
    final confirmedRequestDetails = {
      'userName': name,
      'image': image,
      'places': placesStr,  // Save places as a single string
      'aboutTrip': aboutTripStr,  // Save aboutTrip as a single string
      'expertise': expertiseStr,  // Save expertise as a single string
      'status': 'Confirmed',  // Mark status as Confirmed
      'requestDate': FieldValue.serverTimestamp(),  // Add a timestamp for when the request is confirmed
    };

    // Store the details in the confirmed_requests collection
    await FirebaseFirestore.instance
        .collection('confirmed_requests')
        .doc(requestId)  // Use the requestId to ensure consistency
        .set(confirmedRequestDetails);

    // Update the status of the request in the original requests collection
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .update({'status': 'Confirmed'});

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request for $name has been confirmed!')),
    );

    // Pop the current page and navigate back to the previous screen (GuideDashboard)
    Navigator.pop(context);  // This will remove the current RequestDetailsPage from the stack

  } catch (e) {
    print('Error confirming request: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to confirm request.')),
    );
  }
}


  Future<void> handleDecline(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': 'Declined'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request from $name has been declined.')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error declining request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline request.')),
      );
    }
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
                  backgroundImage: AssetImage(image),
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
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 10, 10, 10)),
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
                  child: const Text('Confirm', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => handleDecline(context),
                  child: const Text('Decline', style: TextStyle(color: Colors.black)),
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
