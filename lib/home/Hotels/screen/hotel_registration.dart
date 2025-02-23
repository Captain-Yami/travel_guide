import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_guide/home/Hotels/screen/hotel_homepage.dart';
import 'dart:io';

import 'package:travel_guide/home/Hotels/screen/hotel_login.dart';
import 'package:travel_guide/home/Hotels/services/hotefirebaseservice.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';

class HotelRegistrationPage extends StatefulWidget {
  const HotelRegistrationPage({super.key});

  @override
  State<HotelRegistrationPage> createState() => _HotelRegistrationPageState();
}

class _HotelRegistrationPageState extends State<HotelRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field values
   final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
    int numberOfRooms = 1;
  bool show=true;

  String? latitude;
  String? longitude;

  // Facilities selection
  bool hasSwimmingPool = false;
  bool hasParking = false;
  bool hasRestaurant = false;
  bool hasBarFacility = false;
  bool hasDJNight = false;
  bool hasLaundryCleaning = false;
  bool hasWifi = false;
  bool hasGym = false;
  bool hasDoctorOnCall = false;
  String acSelection = 'AC'; // Default AC

  bool isLoading = false;

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Image fields
  String? imageUrl;
  String? documnetUrl;
  File? _image; // Holds the selected image file
  File? document;

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '894239764992456',
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',
    cloudName: 'db2nki9dh',
  );

  // Method to pick image
  Future<void> _pickImage({bool isDocument = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery); // You can also use ImageSource.camera

    if (image != null) {
      setState(() {
        if (isDocument) {
          document = File(image.path);
        } else {
          _image = File(image.path);
        }
      });
    }
  }

  // Method to upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      // Upload image to Cloudinary
      final result = await cloudinary.upload(
        file: imageFile.path,
        folder: 'hotels',
        resourceType: CloudinaryResourceType.image,
      );
      return result.secureUrl; // Return the image URL
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

// Get selected facilities
  String _getSelectedFacilities() {
    List<String> facilities = [];
    if (hasSwimmingPool) facilities.add("Swimming Pool");
    if (hasParking) facilities.add("Parking");
    if (hasRestaurant) facilities.add("Restaurant");
    if (hasBarFacility) facilities.add("Bar Facility");
    if (hasDJNight) facilities.add("DJ Night");
    if (hasLaundryCleaning) facilities.add("Laundry and Cleaning");
    if (hasWifi) facilities.add("Wi-Fi");
    if (hasGym) facilities.add("Gym");
    if (hasDoctorOnCall) facilities.add("Doctor on Call");
    return facilities.isNotEmpty ? facilities.join(", ") : "None";
  }

  final user = FirebaseAuth.instance.currentUser;

  // Submit form
  void submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    _formKey.currentState!.save();

    // Validate password and confirm password match
    if (passwordController != confirmPasswordController) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      // Create user in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: contactEmailController.text, 
        password: passwordController.text,
      );
      
      final String userId = userCredential.user!.uid; // Get newly created user ID

      // Upload images to Cloudinary
      if (_image != null && document != null) {
        imageUrl = await _uploadImageToCloudinary(_image!);
        documnetUrl = await _uploadImageToCloudinary(document!);
      }
      
      // Creating a hotel registration model
     

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();

      // Display success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Registration Successful"),
            content: const Text("Hotel registration successful!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to register hotel. Error: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}

  // Input decoration
  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.teal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

   void Registerhotel() async {

    if (_formKey.currentState?.validate() ?? false) {
      // After file upload, continue with the registration login
        hotelfirebaseauthservice().hotelRegister(
          email: contactEmailController.text,
          hotelName: hotelNameController.text,
          Phone_number: contactNumberController.text,
          password: passwordController.text,
          numberOfRooms: numberOfRooms,
          location: locationController.text,
          facilities: _getSelectedFacilities(),
          imageUrl:imageUrl,
          documnetUrl:documnetUrl,  
          context: context,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Registration"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hotel Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Hotel Name
                 TextFormField(
                    controller: hotelNameController,
                    decoration: const InputDecoration(
                      labelText: 'Hotelname',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Hotelname';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                // Contact Email
                 TextFormField(
                    controller: contactEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                // Contact Number
                 TextFormField(
                    controller: contactNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 10) {
                        return 'Phone number should be at least 10 digits';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Phone number can only contain digits';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                 TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // Oval shape
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  // Allow only alphabetic characters
                  RegExp cityRegEx = RegExp(r"^[a-zA-Z\s]+$");
                  if (!cityRegEx.hasMatch(value)) {
                    return 'location name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
                const SizedBox(height: 16),
                // Number of Rooms
               TextFormField(
                  decoration: _buildInputDecoration("No. of Rooms"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the number of rooms";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    numberOfRooms = int.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Password
               TextFormField(
                    controller: passwordController,
                    obscureText: show,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(value)) {
                        return 'Password must include at least one uppercase letter, one lowercase letter, and one number';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                // Confirm Password
               TextFormField(
                    controller: confirmPasswordController,
                    obscureText: show,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                        icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                // Facilities Checkboxes
                const Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: const Text("Swimming Pool"),
                  value: hasSwimmingPool,
                  onChanged: (bool? value) {
                    setState(() {
                      hasSwimmingPool = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Parking"),
                  value: hasParking,
                  onChanged: (bool? value) {
                    setState(() {
                      hasParking = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Restaurant"),
                  value: hasRestaurant,
                  onChanged: (bool? value) {
                    setState(() {
                      hasRestaurant = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Bar Facility"),
                  value: hasBarFacility,
                  onChanged: (bool? value) {
                    setState(() {
                      hasBarFacility = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("DJ Night"),
                  value: hasDJNight,
                  onChanged: (bool? value) {
                    setState(() {
                      hasDJNight = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Laundry and Cleaning"),
                  value: hasLaundryCleaning,
                  onChanged: (bool? value) {
                    setState(() {
                      hasLaundryCleaning = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Wi-Fi"),
                  value: hasWifi,
                  onChanged: (bool? value) {
                    setState(() {
                      hasWifi = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Gym"),
                  value: hasGym,
                  onChanged: (bool? value) {
                    setState(() {
                      hasGym = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Doctor on Call"),
                  value: hasDoctorOnCall,
                  onChanged: (bool? value) {
                    setState(() {
                      hasDoctorOnCall = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                const Text('logo'),
                // Hotel Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Document'),

                GestureDetector(
                  onTap: () {
                    _pickImage(isDocument: true);
                  },
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: document == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(document!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: Registerhotel,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      fixedSize: Size(MediaQuery.of(context).size.width, 50)),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                ),

                const SizedBox(height: 20),
                // Add "Already have an account?" section
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to Hotel Login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
