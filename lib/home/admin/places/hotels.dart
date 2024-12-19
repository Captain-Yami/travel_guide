import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/admin_hotels.dart';

class Hotels extends StatefulWidget {
  const Hotels({super.key});

  @override
  State<Hotels> createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Hotels').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Hotels found'));
          }

          var hotels = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              var hotel = hotels[index].data() as Map<String, dynamic>;
              String hotelId = hotels[index].id;  // Get the document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: InkWell(
                  onTap: () {
                    // Navigate to HotelDetails screen and pass the hotelId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetails(hotelId: hotelId),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hotel name
                          Text(
                            hotel['name'] ?? 'No name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              _showDeleteConfirmationDialog(context, hotelId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddBeachScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelsDetails(locationType: 'Hotels'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
    
  }

  // Function to show the confirmation dialog before deleting a hotel
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String hotelId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Hotel'),
          content: const Text('Are you sure you want to delete this hotel?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the hotel document from Firestore
                await FirebaseFirestore.instance
                .collection('Hotels')
                .doc(hotelId)
                .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hotel deleted successfully!')),
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

class HotelDetails extends StatefulWidget {
  final String hotelId;

  const HotelDetails({Key? key, required this.hotelId}) : super(key: key);

  @override
  _HotelDetailsState createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for each text field
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  late TextEditingController _imageUrlController;

  bool _isEditing = false; // Variable to track if we are in edit mode

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _openingTimeController = TextEditingController();
    _closingTimeController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Fetch the hotel details initially and populate the controllers
    _fetchHotelDetails();
  }

  // Function to fetch hotel details from Firestore
  Future<void> _fetchHotelDetails() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Hotels')
        .doc(widget.hotelId)
        .get();

    if (snapshot.exists) {
      var hotel = snapshot.data() as Map<String, dynamic>;
      _nameController.text = hotel['name'] ?? '';
      _descriptionController.text = hotel['description'] ?? '';
      _openingTimeController.text = hotel['openingTime'] ?? '';
      _closingTimeController.text = hotel['closingTime'] ?? '';
      _imageUrlController.text = hotel['imageUrl'] ?? '';
    }
  }

  // Function to save the edited hotel details to Firestore
  Future<void> _saveHotelDetails() async {
    await _firestore
        .collection('Hotels')
        .doc(widget.hotelId)
        .update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'openingTime': _openingTimeController.text,
      'closingTime': _closingTimeController.text,
      'imageUrl': _imageUrlController.text,
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hotel details updated successfully!')),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _nameController.dispose();
    _descriptionController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore
            .collection('Hotels')
            .doc(widget.hotelId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Hotel not found'));
          }

          var hotel = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Hotel Name'),
                        )
                      : Text(
                          'Hotel Name: ${hotel['name'] ?? 'No name'}',
                          style: TextStyle(fontSize: 18),
                        ),
                  SizedBox(height: 16),

                  // Description
                  _isEditing
                      ? TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                          maxLines: 4,
                        )
                      : Text(
                          'Description: ${hotel['description'] ?? 'No description available'}',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),

                  // Opening Time
                  _isEditing
                      ? TextField(
                          controller: _openingTimeController,
                          decoration: const InputDecoration(labelText: 'Opening Time'),
                        )
                      : Text(
                          'Opening Time: ${hotel['openingTime'] ?? 'No opening time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),

                  // Closing Time
                  _isEditing
                      ? TextField(
                          controller: _closingTimeController,
                          decoration: const InputDecoration(labelText: 'Closing Time'),
                        )
                      : Text(
                          'Closing Time: ${hotel['closingTime'] ?? 'No closing time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),

                  // Image URL
                  _isEditing
                      ? TextField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(labelText: 'Image URL'),
                        )
                      : (hotel['imageUrl'] != null
                          ? Image.network(hotel['imageUrl'])
                          : const Text('No image available')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });

          if (!_isEditing) {
            // Save the data when switching back to view mode
            _saveHotelDetails();
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}
