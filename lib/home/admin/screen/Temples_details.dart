import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TemplesDetails extends StatefulWidget {
  final String locationType;

  const TemplesDetails({super.key, required this.locationType});

  @override
  State<TemplesDetails> createState() => _AddLocationDetailsPageState();
}

class _AddLocationDetailsPageState extends State<TemplesDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seasonalTimeController = TextEditingController();
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  File? _image;
  bool isUploading = false;

  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh', // Replace with your Cloudinary cloud name
    apiKey: '894239764992456', // Replace with your Cloudinary API key
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0', // Replace with your Cloudinary API secret
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

  // Function to upload image to Cloudinary and return the image URL
  Future<String?> _uploadImageToCloudinary() async {
    if (_image == null) return null;

    setState(() {
      isUploading = true;
    });

    // Upload the image to Cloudinary
    final response = await cloudinary.upload(
      file: _image!.path,
      resourceType: CloudinaryResourceType.image,
      folder: 'temples', // Cloudinary folder name
      fileName: 'temple_${DateTime.now().millisecondsSinceEpoch}', // Dynamic file name
    );

    setState(() {
      isUploading = false;
    });

    if (response.isSuccessful) {
      return response.secureUrl; // Return the secure URL of the uploaded image
    } else {
      return null; // If upload fails, return null
    }
  }

  // Function to submit the form and add the data to Firestore
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Upload the image and get the URL
      final imageUrl = await _uploadImageToCloudinary();

      if (imageUrl != null) {
        try {
          // Save the temple details to Firestore
          await FirebaseFirestore.instance.collection('Places').doc('Locations').collection('Temples').add({
            'name': nameController.text,
            'description': descriptionController.text,
            'seasonalTime': seasonalTimeController.text,
            'openingTime': openingTimeController.text,
            'closingTime': closingTimeController.text,
            'imageUrl': imageUrl, // Store the image URL
            'createdAt': Timestamp.now(),
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Temple details added successfully!')));
          _clearForm(); // Clear the form after successful submission
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add data: $e')));
        }
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
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    seasonalTimeController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    super.dispose();
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
                  labelText: 'Pilgrimage Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pilgrimage time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Opening Time text field
              TextFormField(
                controller: openingTimeController,
                decoration: InputDecoration(
                  labelText: 'Morning Time',
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
                  labelText: 'Evening Time',
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
