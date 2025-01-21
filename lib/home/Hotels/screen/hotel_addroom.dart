import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary/cloudinary.dart';

class HotelAddroom extends StatefulWidget {
  const HotelAddroom({super.key});

  @override
  State<HotelAddroom> createState() => _HotelAddRoomState();
}

class _HotelAddRoomState extends State<HotelAddroom> {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text controllers
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Checkbox states
  bool _hasAC = false;
  bool _hasRoomService = false;
  bool _hasWifi = false;
  bool _hasBalcony = false;
  bool _isAvailable = false;

  String? _imageUrl;
  File? _image;
  bool isUploading = false;

  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh',
    apiKey: '894239764992456',
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',
  );

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary() async {
    if (_image == null) return null;

    setState(() {
      isUploading = true;
    });

    try {
      final response = await cloudinary.upload(
        file: _image!.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'hotel_rooms',
        fileName: 'room_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Function to save room data to Firestore under logged-in hotel's account
  Future<void> _saveRoomData() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    print(FirebaseAuth.instance.currentUser?.uid);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue.')),
      );
      return;
    }
    print(FirebaseAuth.instance.currentUser?.uid);


    final roomNumber = _roomNumberController.text;
    final price = _priceController.text;
    final features = {
      'AC': _hasAC,
      'Room Service': _hasRoomService,
      'Wi-Fi': _hasWifi,
      'Balcony': _hasBalcony,
    };
    final availability = _isAvailable;

    try {
      await _firestore
          .collection('hotels')
          .doc(user.uid) // Use the logged-in hotel's unique ID
          .collection('rooms')
          .add({
        'roomNumber': roomNumber,
        'price': price,
        'features': features,
        'isAvailable': availability,
        'imageUrl': _imageUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(), // Track data entry time
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room added successfully!')),
      );

      // Reset form after saving
      _roomNumberController.clear();
      _priceController.clear();
      setState(() {
        _hasAC = false;
        _hasRoomService = false;
        _hasWifi = false;
        _hasBalcony = false;
        _isAvailable = false;
        _imageUrl = null;
      });
    } catch (e) {
      print("Error saving room data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add room: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                child: _image == null
                    ? Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black.withOpacity(0.5),
                          size: 50,
                        ),
                      )
                    : Image.file(
                        _image!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomNumberController,
              decoration: const InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Room Features',
                style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('AC'),
              value: _hasAC,
              onChanged: (bool? value) {
                setState(() {
                  _hasAC = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Room Service'),
              value: _hasRoomService,
              onChanged: (bool? value) {
                setState(() {
                  _hasRoomService = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Wi-Fi'),
              value: _hasWifi,
              onChanged: (bool? value) {
                setState(() {
                  _hasWifi = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Balcony'),
              value: _hasBalcony,
              onChanged: (bool? value) {
                setState(() {
                  _hasBalcony = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Room Availability',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Available'),
              value: _isAvailable,
              onChanged: (bool value) {
                setState(() {
                  _isAvailable = value;
                });
              },
            ),
           
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isUploading ? null : _saveRoomData,
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
