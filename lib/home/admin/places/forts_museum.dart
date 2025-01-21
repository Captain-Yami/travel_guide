import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/fortsMuseum.dart'; // Import the FortsDetailsPage

class adminFortsMuseum extends StatefulWidget {
  const adminFortsMuseum({super.key, required String locationType});

  @override
  State<adminFortsMuseum> createState() => _FortsMuseumState();
}

class _FortsMuseumState extends State<adminFortsMuseum> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forts and Museums List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      body: Stack(
        children: [
          // Apply a Linear Gradient as the background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(12, 22, 21, 1), // Dark black
                  Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
                  Color.fromARGB(255, 14, 26, 25), // Even lighter Green
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('Places')
                .doc('Locations')
                .collection('FortsMuseum')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No Forts and Museums found'));
              }

              var fortsMuseum = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: fortsMuseum.length,
                itemBuilder: (context, index) {
                  var fortMuseum =
                      fortsMuseum[index].data() as Map<String, dynamic>;
                  String fortMuseumId =
                      fortsMuseum[index].id; // Get the document ID

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the FortsDetailsPage when the card is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FortsDetailsPage(
                              fortId: fortMuseumId,
                              name: fortMuseum['name'] ?? 'No name',
                              description:
                                  fortMuseum['description'] ?? 'No description',
                              historicalTime: fortMuseum['historicalTime'] ??
                                  'No historical time',
                              openingTime: fortMuseum['openingTime'] ??
                                  'No opening time',
                              closingTime: fortMuseum['closingTime'] ??
                                  'No closing time',
                              imageUrl: fortMuseum['imageUrl'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.green, // Set the card background to green
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Use Flexible to handle text overflow
                              Flexible(
                                child: Text(
                                  fortMuseum['name'] ?? 'No name',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Black font color
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis when overflow occurs
                                ),
                              ),
                              // Delete button
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Show confirmation dialog before deleting
                                  _showDeleteConfirmationDialog(
                                      context, fortMuseumId);
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddFortsMuseumScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FortsMuseumDetails(locationType: 'FortsMuseum'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a fort and museum
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String fortMuseumId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Forts and Museum'),
          content: const Text(
              'Are you sure you want to delete this fort and museum?'),
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
                // Delete the fort and museum document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('FortsMuseum')
                    .doc(fortMuseumId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Forts and Museum deleted successfully!')),
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

class FortsDetailsPage extends StatefulWidget {
  final String fortId;
  final String name;
  final String description;
  final String historicalTime;
  final String openingTime;
  final String closingTime;
  final String imageUrl;

  const FortsDetailsPage({
    super.key,
    required this.fortId,
    required this.name,
    required this.description,
    required this.historicalTime,
    required this.openingTime,
    required this.closingTime,
    required this.imageUrl,
  });

  @override
  State<FortsDetailsPage> createState() => _FortsDetailsPageState();
}

class _FortsDetailsPageState extends State<FortsDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _historicalTimeController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;

  bool _isEditing = false; // Flag to toggle between edit and view mode

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the initial data
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _historicalTimeController =
        TextEditingController(text: widget.historicalTime);
    _openingTimeController = TextEditingController(text: widget.openingTime);
    _closingTimeController = TextEditingController(text: widget.closingTime);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _nameController.dispose();
    _descriptionController.dispose();
    _historicalTimeController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  // Function to save updated data to Firestore
  Future<void> _updateFortsDetails() async {
    await FirebaseFirestore.instance
        .collection('Places')
        .doc('Locations')
        .collection('Forts')
        .doc(widget.fortId)
        .update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'historicalTime': _historicalTimeController.text,
      'openingTime': _openingTimeController.text,
      'closingTime': _closingTimeController.text,
      'imageUrl':
          widget.imageUrl, // If you don't want to edit image, keep it as is
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forts details updated successfully!')),
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
                .collection('FortsMuseum')
                .doc(widget.fortId)
                .snapshots(), // Listen for real-time updates
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Forts details not found.'));
              }

              var fortData = snapshot.data!;
              // Set the fetched data dynamically
              String name = fortData['name'];
              String description = fortData['description'];
              String openingTime = fortData['openingTime'];
              String closingTime = fortData['closingTime'];

              // Update controllers with fetched data if not in edit mode
              if (!_isEditing) {
                _nameController.text = name;
                _descriptionController.text = description;
                _openingTimeController.text = openingTime;
                _closingTimeController.text = closingTime;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fort image
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
                                  controller: _historicalTimeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Historical Time',
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
            _updateFortsDetails();
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}
