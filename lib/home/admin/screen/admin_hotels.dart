import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelsDetails extends StatefulWidget {
  const HotelsDetails({super.key, required String locationType});

  @override
  State<HotelsDetails> createState() => _HotelsDetailsState();
}

class _HotelsDetailsState extends State<HotelsDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();

  File? _image;
  bool isUploading = false;

  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh',
    apiKey: '894239764992456',
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',
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

    final response = await cloudinary.upload(
      file: _image!.path,
      resourceType: CloudinaryResourceType.image,
      folder: 'hotels',  // Specify folder as 'hotels'
      fileName: 'hotel_${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      isUploading = false;
    });

    if (response.isSuccessful) {
      return response.secureUrl;
    } else {
      return null;
    }
  }

  // Function to store the hotel data in Firestore
  Future<void> _storeHotelData(String imageUrl) async {
    final hotelData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'openingTime': _openingTimeController.text,
      'closingTime': _closingTimeController.text,
      'imageUrl': imageUrl,
    };

    try {
      await FirebaseFirestore.instance.collection('Hotels').add(hotelData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel Data Submitted Successfully')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit hotel data')),
      );
    }
  }

  // Clear the form fields
  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _openingTimeController.clear();
    _closingTimeController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel Details'),
        backgroundColor: Colors.black,
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
              const SizedBox(height: 20),
              
              Text(
                'Enter details for the hotel:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Name text field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hotel Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hotel name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description text field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Hotel Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Location text field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Hotel Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Opening Time text field
              TextFormField(
                controller: _openingTimeController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),

              // Closing Time text field
              TextFormField(
                controller: _closingTimeController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: isUploading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    if (_image != null) {
                      try {
                        // Upload image and get the URL
                        String? imageUrl = await _uploadImageToCloudinary();
                        if (imageUrl != null) {
                          // Store data in Firestore
                          await _storeHotelData(imageUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image upload failed')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to upload image')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an image')),
                      );
                    }
                  }
                },
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Hotel'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
