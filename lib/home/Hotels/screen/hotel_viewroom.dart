import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookedRoomsPage extends StatelessWidget {
  const BookedRoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentHotelId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Rooms',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent)),
        backgroundColor: const Color(0xFF0C1615),
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C1615), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('hotels')
              .doc(currentHotelId)
              .collection('bookings')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No rooms booked yet',
                      style: TextStyle(color: Colors.greenAccent)));
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final roomNumber = booking['roomNumber'] ?? 'Unknown';
                final userName = booking['userName'] ?? 'Guest';
                final userEmail = booking['userEmail'] ?? 'N/A';
                final checkInDate = booking['checkInDate'] ?? 'Unknown';
                final checkOutDate = booking['checkOutDate'] ?? 'Unknown';
                final amountPaid = booking['amount'] ?? '0';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  color: Colors.black.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Text(
                      'Room $roomNumber',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.greenAccent),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booked by: $userName',
                            style: const TextStyle(color: Colors.white70)),
                        Text('Email: $userEmail',
                            style: const TextStyle(color: Colors.white70)),
                        Text('Check-in: $checkInDate',
                            style: const TextStyle(color: Colors.white70)),
                        Text('Check-out: $checkOutDate',
                            style: const TextStyle(color: Colors.white70)),
                        Text('Amount Paid: \$${amountPaid}',
                            style: const TextStyle(color: Colors.greenAccent)),
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
