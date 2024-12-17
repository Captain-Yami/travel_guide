import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_guide/home/admin/services/firebaseAddbeaches.dart'; // Add firebase service for Firestore

class BeachesDetails extends StatefulWidget {
  final String locationType;

  const BeachesDetails({super.key, required this.locationType});

  @override
  State<BeachesDetails> createState() => _AddLocationDetailsPageState();
}

class _AddLocationDetailsPageState extends State<BeachesDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seasonalTimeController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  File? _image;
  bool isUploading = false;
final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh',  // Replace with your Cloudinary cloud name
    apiKey: '894239764992456',  // Replace with your API key
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',  // Replace with your API secret
  );
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
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    seasonalTimeController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    super.dispose();
  }

  // Function to upload image to Cloudinary and return the image URL
  Future<String?> _uploadImageToCloudinary() async {
    if (_image == null) return null;

    setState(() {
      isUploading = true;
    });

    // Uploading the image to Cloudinary
    final response = await cloudinary.upload(
      file: _image!.path,
      resourceType: CloudinaryResourceType.image,
      folder: 'beaches',  // Specify folder as 'beaches'
      fileName: 'beach_${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      isUploading = false;
    });

    if (response.isSuccessful) {
      return response.secureUrl;  // Return the secure URL of the uploaded image
    } else {
      // Handle error in uploading image
      return null;
    }
  }

  // Function to submit the form and add the data to Firestore
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Upload the image first and get the URL
      final imageUrl = await _uploadImageToCloudinary();

      if (imageUrl != null) {
        // Now store the data in Firestore
        FirebaseFirestore.instance.collection('Places').doc('Locations').collection('Beaches').add({
          'name': nameController.text,
          'description': descriptionController.text,
          'seasonalTime': seasonalTimeController.text,
          'openingTime': openingTimeController.text,
          'closingTime': closingTimeController.text,
          'imageUrl': imageUrl,  // Save the image URL
          'createdAt': Timestamp.now(),
        }).then((value) {
          // Show success message and reset the form
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Beach details added successfully!')));
          _clearForm();
        }).catchError((error) {
          // Handle error while adding data to Firestore
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add data: $error')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image upload failed!')));
      }
    }
  }

  // Clear the form fields
  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    seasonalTimeController.clear();
    openingTimeController.clear();
    closingTimeController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add ${widget.locationType} Details'),
      ),
      body: SingleChildScrollView(
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
                onPressed: isUploading ? null : _submitForm,  // Disable when uploading
                child: isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit'),
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
