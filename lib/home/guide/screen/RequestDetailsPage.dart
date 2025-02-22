import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDetailsPage extends StatefulWidget {
  final String requestId;
  final String name;
  final String image;
  final List<String> placesToVisit;
  final List<String> interestedCategories;
  final String details;
  final String startDate;
  final String endDate;
  final String user;
  final String guideId;
  final Function(String) onRemoveRequest;

  const RequestDetailsPage({
    Key? key,
    required this.requestId,
    required this.name,
    required this.image,
    required this.placesToVisit,
    required this.interestedCategories,
    required this.details,
    required this.startDate,
    required this.endDate,
    required this.user,
    required this.onRemoveRequest,
    required this.guideId,
  }) : super(key: key);

  @override
  _RequestDetailsPageState createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String status = "Pending";

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final doc = await _firestore.collection('requests').doc(widget.requestId).get();
      if (doc.exists) {
        setState(() {
          status = doc['status'] ?? "Pending";
        });
      }
    } catch (e) {
      debugPrint('Error loading status: $e');
    }
  }

  Future<void> handleConfirmation(BuildContext context) async {
    try {
      String placesStr = widget.placesToVisit.join(', ');
      String aboutTripStr = widget.details;
      String expertiseStr = widget.interestedCategories.join(', ');

      final confirmedRequestDetails = {
        'guideId' : widget.guideId,
        'userName': widget.name,
        'image': widget.image,
        'places': placesStr,
        'aboutTrip': aboutTripStr,
        'expertise': expertiseStr,
        'status': 'Confirmed',
        'requestDate': FieldValue.serverTimestamp(),
        'user': widget.user,
      };

      await _firestore
          .collection('confirmed_requests')
          .doc(widget.requestId)
          .set(confirmedRequestDetails);

      await _firestore.collection('requests').doc(widget.requestId).delete();

      widget.onRemoveRequest(widget.requestId); // Remove from local UI

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request for ${widget.name} has been confirmed!')),
      );

      Navigator.pop(context); // Navigate back after confirmation
    } catch (e) {
      debugPrint('Error confirming request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to confirm request.')),
      );
    }
  }

  Future<void> handleDecline(BuildContext context) async {
    try {
      await _firestore.collection('requests').doc(widget.requestId).delete();

      widget.onRemoveRequest(widget.requestId); // Remove from local UI

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request from ${widget.name} has been declined.')),
      );

      Navigator.pop(context); // Navigate back after decline
    } catch (e) {
      debugPrint('Error declining request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to decline request.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.name}\'s Request Details',
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
                  backgroundImage: AssetImage(widget.image),
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $status',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 10, 10, 10),
                      ),
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
            Text(widget.details),
            const SizedBox(height: 16),
            const Text(
              'Interested Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.interestedCategories.join(', ')),
            const SizedBox(height: 16),
             const Text(
              'Start Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.startDate),
            const SizedBox(height: 16),
            const Text(
              'End Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.endDate),
            const SizedBox(height: 16),
            const Text(
              'Places to Visit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.placesToVisit.join(', ')),
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
                  onPressed: () => handleDecline(context),
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
