import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddLocationDetailsPage extends StatefulWidget {
  final String locationType;

  // Constructor to accept the location type (e.g., 'Beaches', 'Temples', etc.)
  const AddLocationDetailsPage({super.key, required this.locationType});

  @override
  State<AddLocationDetailsPage> createState() => _AddLocationDetailsPageState();
}

class _AddLocationDetailsPageState extends State<AddLocationDetailsPage> {
  // Controllers for each text field
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seasonalTimeController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  // Variable to store the selected image
  File? _image;

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add ${widget.locationType} Details'),
      ),
      body: SingleChildScrollView(  // Wrapping the entire body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image upload section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black.withOpacity(0.5),
                            size: 50,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Enter details for ${widget.locationType}:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              // Name text field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Description text field
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Location Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Seasonal Time text field
              TextFormField(
                controller: seasonalTimeController,
                decoration: InputDecoration(
                  labelText: 'Seasonal Time (e.g., Winter, Summer)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seasonal time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Opening Time text field
              TextFormField(
                controller: openingTimeController,
                decoration: InputDecoration(
                  labelText: 'Opening Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the opening time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Closing Time text field
              TextFormField(
                controller: closingTimeController,
                decoration: InputDecoration(
                  labelText: 'Closing Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the closing time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Perform the action for saving the details.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${widget.locationType} added successfully')));

                    // Clear the text fields after submission
                    nameController.clear();
                    descriptionController.clear();
                    seasonalTimeController.clear();
                    openingTimeController.clear();
                    closingTimeController.clear();
                    setState(() {
                      _image = null; // Reset image after submission
                    });
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
