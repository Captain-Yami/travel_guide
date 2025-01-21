import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // To interact with Firestore

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();
  bool _isLoading = false;

  // Fetching the list of rooms (both booked and available) from Firestore
  Future<List<DocumentSnapshot>> _getRooms() async {
    var snapshot = await FirebaseFirestore.instance.collection('rooms').get();
    return snapshot.docs;
  }

  // Add room details to the Firestore collection
  Future<void> _addRoom() async {
    if (_hotelNameController.text.isEmpty ||
        _roomTypeController.text.isEmpty ||
        _roomPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'hotelName': _hotelNameController.text,
        'roomType': _roomTypeController.text,
        'price': double.parse(_roomPriceController.text),
        'isBooked': false, // New rooms are initially available
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room added successfully")),
      );

      _hotelNameController.clear();
      _roomTypeController.clear();
      _roomPriceController.clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred, please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Homepage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hotel Details Section
            TextField(
              controller: _hotelNameController,
              decoration: const InputDecoration(
                labelText: 'Hotel Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomTypeController,
              decoration: const InputDecoration(
                labelText: 'Room Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomPriceController,
              decoration: const InputDecoration(
                labelText: 'Room Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Add Room Button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _addRoom,
                    child: const Text('Add Room'),
                  ),
            const SizedBox(height: 24),

            // Room List Section: Display Booked and Available Rooms
            FutureBuilder<List<DocumentSnapshot>>(
              future: _getRooms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No rooms available");
                }

                var rooms = snapshot.data!;
                var availableRooms = rooms.where((room) => room['isBooked'] == false).toList();
                var bookedRooms = rooms.where((room) => room['isBooked'] == true).toList();

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Rooms',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...availableRooms.map((room) => ListTile(
                            title: Text(room['roomType']),
                            subtitle: Text("Price: \$${room['price']}"),
                            trailing: const Text('Available'),
                          )),
                      const SizedBox(height: 24),
                      const Text(
                        'Booked Rooms',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...bookedRooms.map((room) => ListTile(
                            title: Text(room['roomType']),
                            subtitle: Text("Price: \$${room['price']}"),
                            trailing: const Text('Booked'),
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
