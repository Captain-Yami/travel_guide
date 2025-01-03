import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback extends StatefulWidget {

  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  final currentUser= FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Guide')
            .doc(currentUser)
            .collection('feedback')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading feedback.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback available.'));
          }

          final feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              final userId = feedback['userId']; 
              final feedbackText = feedback['feedback'];
              final rating = feedback['rating'].toDouble();
              
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading feedback details...'),
                    );
                  }

                  if (userSnapshot.hasError ||
                      !userSnapshot.hasData ||
                      !userSnapshot.data!.exists) {
                    return ListTile(
                      title: const Text('User information not found'),
                      subtitle: Text(feedbackText),
                    );
                  }

                  final userName = userSnapshot.data!.get('name') ?? 'Unknown User';

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feedbackText,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
