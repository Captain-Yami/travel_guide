import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewRooms extends StatefulWidget {
  @override
  _ViewRoomsState createState() => _ViewRoomsState();
}

class _ViewRoomsState extends State<ViewRooms> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  String hotelName = "";

  @override
  void initState() {
    super.initState();
    _fetchHotelDetails();
  }

  void _fetchHotelDetails() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('hotels')
        .doc(currentUserId)
        .get();
    if (userDoc.exists) {
      setState(() {
        hotelName = userDoc['hotelName'] ?? "Unknown Hotel";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hotelName - Rooms',
            style: const TextStyle(
                fontSize: 22,
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
              .doc(currentUserId)
              .collection('rooms')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No rooms available',
                      style: TextStyle(color: Colors.greenAccent)));
            }

            final rooms = snapshot.data!.docs;

            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final roomNumber = room['roomNumber'] ?? 'Unknown';
                final roomPrice = room['price'] ?? '0';
                final roomImage = room['imageUrl'] ?? '';
                final features = room['features'] ?? {};
                final ac = features['AC'] ?? false;
                final balcony = features['Balcony'] ?? false;
                final roomService = features['Room Service'] ?? false;
                final wifi = features['Wi-Fi'] ?? false;
                final isAvailable = room['isAvailable'] ?? false;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 5,
                  color: Colors.black.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: roomImage.isNotEmpty
                              ? Image.network(roomImage,
                                  width: 60, height: 60, fit: BoxFit.cover)
                              : const Icon(Icons.bed,
                                  size: 60, color: Colors.greenAccent),
                        ),
                        title: Text('Room $roomNumber',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.greenAccent)),
                        subtitle: Text('Price: \$${roomPrice}',
                            style: const TextStyle(color: Colors.white70)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Features:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.greenAccent)),
                            Text('AC: ${ac ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Balcony: ${balcony ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Room Service: ${roomService ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Wi-Fi: ${wifi ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Available: ${isAvailable ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
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
