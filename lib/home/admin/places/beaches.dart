import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/screen/Beaches_details.dart';

class adminBeaches extends StatefulWidget {
  const adminBeaches({super.key, required String locationType});

  @override
  State<adminBeaches> createState() => _BeachesState();
}

class _BeachesState extends State<adminBeaches> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beaches List'),
        backgroundColor: Colors.blueGrey[800], // Darker AppBar color
      ),
      backgroundColor: Colors.grey[100], // Light grey background for the screen
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('Beaches')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Beaches found'));
          }

          var beaches = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: beaches.length,
            itemBuilder: (context, index) {
              var beach = beaches[index].data() as Map<String, dynamic>;
              String beachId = beaches[index].id;  // Get the document ID

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: InkWell(
                  onTap: () {
                    // Navigate to BeachDetails screen and pass the beachId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeachDetails(beachId: beachId),
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
                          // Beach name
                          Text(
                            beach['name'] ?? 'No name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              _showDeleteConfirmationDialog(context, beachId);
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
              builder: (context) => BeachesDetails(locationType: 'Beaches'),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a beach
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String beachId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Beach'),
          content: const Text('Are you sure you want to delete this beach?'),
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
                // Delete the beach document from Firestore
                await _firestore
                    .collection('Places')
                    .doc('Locations')
                    .collection('Beaches')
                    .doc(beachId)
                    .delete();

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Beach deleted successfully!')),
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

class BeachDetails extends StatefulWidget {
  final String beachId;

  const BeachDetails({Key? key, required this.beachId}) : super(key: key);

  @override
  _BeachDetailsState createState() => _BeachDetailsState();
}

class _BeachDetailsState extends State<BeachDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for each text field
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  late TextEditingController _seasonalTimeController;
  late TextEditingController _imageUrlController;

  bool _isEditing = false; // Variable to track if we are in edit mode

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _openingTimeController = TextEditingController();
    _closingTimeController = TextEditingController();
    _seasonalTimeController = TextEditingController();
    _imageUrlController = TextEditingController();

    // Fetch the beach details initially and populate the controllers
    _fetchBeachDetails();
  }

  // Function to fetch beach details from Firestore
  Future<void> _fetchBeachDetails() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Places')
        .doc('Locations')
        .collection('Beaches')
        .doc(widget.beachId)
        .get();

    if (snapshot.exists) {
      var beach = snapshot.data() as Map<String, dynamic>;
      _nameController.text = beach['name'] ?? '';
      _descriptionController.text = beach['description'] ?? '';
      _openingTimeController.text = beach['openingTime'] ?? '';
      _closingTimeController.text = beach['closingTime'] ?? '';
      _seasonalTimeController.text = beach['seasonalTime'] ?? '';
      _imageUrlController.text = beach['imageUrl'] ?? '';
    }
  }

  // Function to save the edited beach details to Firestore
  Future<void> _saveBeachDetails() async {
    await _firestore
        .collection('Places')
        .doc('Locations')
        .collection('Beaches')
        .doc(widget.beachId)
        .update({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'openingTime': _openingTimeController.text,
      'closingTime': _closingTimeController.text,
      'seasonalTime': _seasonalTimeController.text,
      'imageUrl': _imageUrlController.text,
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Beach details updated successfully!')),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _nameController.dispose();
    _descriptionController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _seasonalTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beach Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore
            .collection('Places')
            .doc('Locations')
            .collection('Beaches')
            .doc(widget.beachId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Beach not found'));
          }

          var beach = snapshot.data!.data() as Map<String, dynamic>;

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
                          decoration: const InputDecoration(labelText: 'Beach Name'),
                        )
                      : Text(
                          'Beach Name: ${beach['name'] ?? 'No name'}',
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
                          'Description: ${beach['description'] ?? 'No description available'}',
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
                          'Opening Time: ${beach['openingTime'] ?? 'No opening time'}',
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
                          'Closing Time: ${beach['closingTime'] ?? 'No closing time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),

                  // Seasonal Time
                  _isEditing
                      ? TextField(
                          controller: _seasonalTimeController,
                          decoration: const InputDecoration(labelText: 'Seasonal Time'),
                        )
                      : Text(
                          'Seasonal Time: ${beach['seasonalTime'] ?? 'No seasonal time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),

                  // Image URL
                  _isEditing
                      ? TextField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(labelText: 'Image URL'),
                        )
                      : (beach['imageUrl'] != null
                          ? Image.network(beach['imageUrl'])
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
            _saveBeachDetails();
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}
