import 'package:flutter/material.dart';

// Define a model to represent the hotel
class Hotel {
  final String name;
  final String description;

  Hotel({required this.name, required this.description});
}

class AdminHotels extends StatefulWidget {
  const AdminHotels({super.key});

  @override
  State<AdminHotels> createState() => _AdminHotelsState();
}

class _AdminHotelsState extends State<AdminHotels> {
  // Sample list of hotels
  List<Hotel> hotels = [
    Hotel(name: 'Hotel Sunshine', description: 'A luxury hotel with great amenities.'),
    Hotel(name: 'Mountain Retreat', description: 'A peaceful getaway in the mountains.'),
    Hotel(name: 'Seaside Resort', description: 'A beautiful resort by the beach.'),
  ];

  // Function to delete a hotel
  void deleteHotel(int index) {
    setState(() {
      hotels.removeAt(index);
    });
  }

  // Function to navigate to hotel details page
  void navigateToHotelDetails(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailsPage(hotel: hotel),
      ),
    );
  }

  // Function to show a dialog for adding a new hotel
  void showAddHotelDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Hotel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Hotel Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Hotel Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new hotel
                setState(() {
                  hotels.add(Hotel(
                    name: nameController.text,
                    description: descriptionController.text,
                  ));
                });
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Add Hotel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Hotels')),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(hotel.name),
              subtitle: Text(hotel.description),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteHotel(index), // Delete the hotel
              ),
              onTap: () => navigateToHotelDetails(hotel), // Navigate to details
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddHotelDialog, // Show the add hotel dialog
        child: Icon(Icons.add),
        tooltip: 'Add Hotel',
      ),
    );
  }
}

class HotelDetailsPage extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailsPage({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotel.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              hotel.description,
              style: TextStyle(fontSize: 18),
            ),
            // Add any other details you need here
          ],
        ),
      ),
    );
  }
}
