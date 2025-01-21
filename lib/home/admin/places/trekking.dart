import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/Trekking_details.dart';

class adminTrekking extends StatefulWidget {
  const adminTrekking({super.key, required String locationType});

  @override
  State<adminTrekking> createState() => _TrekkingState();
}

class _TrekkingState extends State<adminTrekking> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trekking List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      // Background gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Places')
              .doc('Locations')
              .collection('Trekking')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Trekking places found'));
            }

            var trekking = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: trekking.length,
              itemBuilder: (context, index) {
                var trek = trekking[index].data() as Map<String, dynamic>;
                String trekId = trekking[index].id; // Get the document ID

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: InkWell(
                    onTap: () {
                      // Navigate to the details page when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrekkingDetailsPage(
                            trekId: trekId,
                            name: trek['name'] ?? 'No name',
                            description:
                                trek['description'] ?? 'No description',
                            seasonalTime:
                                trek['seasonalTime'] ?? 'No seasonal time',
                            openingTime:
                                trek['openingTime'] ?? 'No opening time',
                            closingTime:
                                trek['closingTime'] ?? 'No closing time',
                            imageUrl: trek['imageUrl'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.green, // Green card color
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Trek name with ellipsis if it overflows
                            Expanded(
                              child: Text(
                                trek['name'] ?? 'No name',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Black font color
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Avoid text overflow
                                maxLines: 1, // Limit to one line
                              ),
                            ),
                            // Delete button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog before deleting
                                _showDeleteConfirmationDialog(context, trekId);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTrekkingScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrekkingDetails(locationType: 'Trekking'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a trekking
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String trekId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Trekking Place'),
          content: const Text(
              'Are you sure you want to delete this trekking place?'),
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
                // Delete the trekking document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('Trekking')
                    .doc(trekId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Trekking place deleted successfully!')),
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
}

class TrekkingDetailsPage extends StatefulWidget {
  final String trekId;
  final String name;
  final String description;
  final String seasonalTime;
  final String openingTime;
  final String closingTime;
  final String imageUrl;

  const TrekkingDetailsPage({
    super.key,
    required this.trekId,
    required this.name,
    required this.description,
    required this.seasonalTime,
    required this.openingTime,
    required this.closingTime,
    required this.imageUrl,
  });

  @override
  State<TrekkingDetailsPage> createState() => _TrekkingDetailsPageState();
}

class _TrekkingDetailsPageState extends State<TrekkingDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _seasonalTimeController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;

  bool _isEditing = false; // Flag to toggle between edit and view mode

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the initial data
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _seasonalTimeController = TextEditingController(text: widget.seasonalTime);
    _openingTimeController = TextEditingController(text: widget.openingTime);
    _closingTimeController = TextEditingController(text: widget.closingTime);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _nameController.dispose();
    _descriptionController.dispose();
    _seasonalTimeController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  // Function to save updated data to Firestore
  Future<void> _updateTrekkingDetails() async {
    await FirebaseFirestore.instance
        .collection('Places')
        .doc('Locations')
        .collection('Trekking')
        .doc(widget.trekId)
        .update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'seasonalTime': _seasonalTimeController.text,
      'openingTime': _openingTimeController.text,
      'closingTime': _closingTimeController.text,
      'imageUrl':
          widget.imageUrl, // If you don't want to edit image, keep it as is
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trekking details updated successfully!')),
    );

    setState(() {
      // Switch to view mode
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_nameController.text), // Show the name here dynamically
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(12, 22, 21, 1), // Dark black
                  Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
                  Color.fromARGB(255, 14, 26, 25), // Even lighter green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Places')
                .doc('Locations')
                .collection('Trekking')
                .doc(widget.trekId)
                .snapshots(), // Listen for real-time updates
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Trekking details not found.'));
              }

              var trekData = snapshot.data!;
              // Set the fetched data dynamically
              String name = trekData['name'];
              String description = trekData['description'];
              String seasonalTime = trekData['seasonalTime'];
              String openingTime = trekData['openingTime'];
              String closingTime = trekData['closingTime'];

              // Update controllers with fetched data if not in edit mode
              if (!_isEditing) {
                _nameController.text = name;
                _descriptionController.text = description;
                _seasonalTimeController.text = seasonalTime;
                _openingTimeController.text = openingTime;
                _closingTimeController.text = closingTime;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trekking image
                      widget.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.imageUrl) // Display image if available
                          : Container(),
                      const SizedBox(height: 16),
                      // Editable fields if in edit mode
                      _isEditing
                          ? Column(
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                  ),
                                  style: TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                  ),
                                  style: TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _seasonalTimeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Seasonal Time',
                                  ),
                                  style: TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _openingTimeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Opening Time',
                                  ),
                                  style: TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _closingTimeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Closing Time',
                                  ),
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'Name: $name',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Description: $description',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Seasonal Time: $seasonalTime',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Opening Time: $openingTime',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Closing Time: $closingTime',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Toggle between edit mode and view mode
            _isEditing = !_isEditing;
          });
          if (!_isEditing) {
            // If switching from edit mode to view mode, save the changes
            _updateTrekkingDetails();
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}
