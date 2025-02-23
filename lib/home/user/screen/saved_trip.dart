import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TravelSchedulePage extends StatelessWidget {
  const TravelSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Schedule', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.green[700], // App bar color
        iconTheme: const IconThemeData(color: Colors.green), // Back button color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
           colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ], // 3-color gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('travel')
              .orderBy('created_at', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading schedule', style: TextStyle(color: Colors.green)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No schedule found.', style: TextStyle(color: Colors.green)));
            }

            // Extract documents
            var schedules = snapshot.data!.docs;

            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                var schedule = schedules[index].data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.7), // Card with slight transparency
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      schedule['place_name'] ?? 'Unknown Place',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time: ${schedule['time'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.green)),
                        Text("Activity: ${schedule['activity'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
