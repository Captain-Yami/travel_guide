import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminComplaints extends StatefulWidget {
  const AdminComplaints({super.key});

  @override
  State<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends State<AdminComplaints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Feedback",
              style: TextStyle(color: Colors.green)),
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(12, 22, 21, 1), // Dark black
                Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
                Color.fromARGB(255, 14, 26, 25), // Even lighter black
              ], // Three colors for gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Feedback').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No feedback available.'));
              }

              // Extract feedback data
              List<DocumentSnapshot> feedbackDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: feedbackDocs.length,
                itemBuilder: (context, index) {
                  var feedbackData =
                      feedbackDocs[index].data() as Map<String, dynamic>;

                  String feedback =
                      feedbackData['feedback'] ?? 'No feedback provided';
                  String userName = feedbackData['userName'] ??
                      'Unknown User'; // Optional: Add a name field

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.green, // Set the card color to green
                    child: ListTile(
                      title: Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set font color to black
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to detailed feedback view
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeedbackDetailPage(
                              userName: userName,
                              feedback: feedback,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

class FeedbackDetailPage extends StatelessWidget {
  final String userName;
  final String feedback;

  const FeedbackDetailPage({
    super.key,
    required this.userName,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: $userName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              feedback,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
