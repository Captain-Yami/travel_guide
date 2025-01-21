import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/Temples_details.dart'; // Import the TempleDetails page

class adminTemples extends StatefulWidget {
  const adminTemples({super.key, required String locationType});

  @override
  State<adminTemples> createState() => _BeachesState();
}

class _BeachesState extends State<adminTemples> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temples List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25), // Even lighter black
            ], // Three colors for gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Places')
              .doc('Locations')
              .collection('Temples')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Temples found'));
            }

            var temples = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: temples.length,
              itemBuilder: (context, index) {
                var temple = temples[index].data() as Map<String, dynamic>;
                String templeId = temples[index].id;  // Get the document ID

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the TempleDetails screen and pass the data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TempleDetails(
                            templeId: templeId,
                            name: temple['name'],
                            description: temple['description'],
                            seasonalTime: temple['seasonalTime'],
                            openingTime: temple['openingTime'],
                            closingTime: temple['closingTime'],
                            imageUrl: temple['imageUrl'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.green, // Set the card color to green
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Temple name
                            Text(
                              temple['name'] ?? 'No name',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // White font color for visibility
                              ),
                            ),
                            // Delete button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog before deleting
                                _showDeleteConfirmationDialog(context, templeId);
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
          // Navigate to the AddBeachScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TemplesDetails(locationType: 'Temples'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a temple
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String templeId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Temple'),
          content: const Text('Are you sure you want to delete this temple?'),
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
                // Delete the temple document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('Temples')
                    .doc(templeId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Temple deleted successfully!')),
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






class TempleDetails extends StatefulWidget {
  final String templeId;
  final String name;
  final String description;
  final String seasonalTime;
  final String openingTime;
  final String closingTime;
  final String imageUrl;

  // Constructor to receive data from the previous screen
  const TempleDetails({
    super.key,
    required this.templeId,
    required this.name,
    required this.description,
    required this.seasonalTime,
    required this.openingTime,
    required this.closingTime,
    required this.imageUrl,
  });

  @override
  _TempleDetailsState createState() => _TempleDetailsState();
}

class _TempleDetailsState extends State<TempleDetails> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _seasonalTimeController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  late TextEditingController _imageUrlController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current temple data
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _seasonalTimeController = TextEditingController(text: widget.seasonalTime);
    _openingTimeController = TextEditingController(text: widget.openingTime);
    _closingTimeController = TextEditingController(text: widget.closingTime);
    _imageUrlController = TextEditingController(text: widget.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _seasonalTimeController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Function to save the updated details to Firestore
  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('Places')
          .doc('Locations')
          .collection('Temples')
          .doc(widget.templeId)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'seasonalTime': _seasonalTimeController.text,
        'openingTime': _openingTimeController.text,
        'closingTime': _closingTimeController.text,
        'imageUrl': _imageUrlController.text,
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Temple details updated successfully!')),
      );

      // Update state to reflect changes
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update temple details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Temple' : widget.name),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.transparent,  // Set transparent to allow gradient
      body: Container(
        width: double.infinity,  // Ensure full width
        height: double.infinity,  // Ensure full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615), // Dark green shade
              Color(0xFF0E3923), // Slightly lighter green
              Color(0xFF1C5A46), // Even lighter green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.zero,  // Remove any extra padding from container
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temple image
              widget.imageUrl.isNotEmpty
                  ? Image.network(widget.imageUrl) // Display image if available
                  : Container(),
              const SizedBox(height: 16),
              // Editable fields
              _isEditing
                  ? Column(
                      children: [
                        _buildTextField(_nameController, 'Temple Name'),
                        _buildTextField(_descriptionController, 'Description'),
                        _buildTextField(_seasonalTimeController, 'Seasonal Time'),
                        _buildTextField(_openingTimeController, 'Opening Time'),
                        _buildTextField(_closingTimeController, 'Closing Time'),
                      ],
                    )
                  : Column(
                      children: [
                        _buildDetailText('Name: ${_nameController.text}'),
                        _buildDetailText('Description: ${_descriptionController.text}'),
                        _buildDetailText('Seasonal Time: ${_seasonalTimeController.text}'),
                        _buildDetailText('Opening Time: ${_openingTimeController.text}'),
                        _buildDetailText('Closing Time: ${_closingTimeController.text}'),
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditing) {
            // Save changes if editing
            _saveChanges();
          } else {
            // Enable editing if not already in editing mode
            setState(() {
              _isEditing = true;
            });
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Helper widget to create a TextField
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green), // Green text color for labels
          border: OutlineInputBorder(),
        ),
        maxLines: label == 'Description' ? null : 1, // Multiline for Description
      ),
    );
  }

  // Helper widget to display the details
  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.green), // Green text color
      ),
    );
  }
}
