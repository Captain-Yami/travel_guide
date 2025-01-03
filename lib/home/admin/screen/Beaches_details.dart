import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<File> _images = [];
  bool isUploading = false;

  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh', // Replace with your Cloudinary cloud name
    apiKey: '894239764992456', // Replace with your API key
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0', // Replace with your API secret
  );

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
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

  Future<List<String>> _uploadImagesToCloudinary() async {
    List<String> imageUrls = [];
    setState(() {
      isUploading = true;
    });

    for (var image in _images) {
      final response = await cloudinary.upload(
        file: image.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'beaches',
        fileName: 'beach_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isSuccessful) {
        imageUrls.add(response.secureUrl!);
      } else {
        setState(() {
          isUploading = false;
        });
        return [];
      }
    }

    setState(() {
      isUploading = false;
    });
    return imageUrls;
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one image.')),
        );
        return;
      }

      final imageUrls = await _uploadImagesToCloudinary();

      if (imageUrls.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('Places')
            .doc('Locations')
            .collection('Beaches')
            .add({
          'name': nameController.text,
          'description': descriptionController.text,
          'seasonalTime': seasonalTimeController.text,
          'openingTime': openingTimeController.text,
          'closingTime': closingTimeController.text,
          'imageUrl': imageUrls, // Save the list of image URLs
          'createdAt': Timestamp.now(),
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Beach details added successfully!')));
          _clearForm();
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add data: $error')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed!')),
        );
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    seasonalTimeController.clear();
    openingTimeController.clear();
    closingTimeController.clear();
    setState(() {
      _images = [];
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _images.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black.withOpacity(0.5),
                            size: 50,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    _images[index],
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _images.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter details for ${widget.locationType}:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: isUploading ? null : _submitForm,
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
