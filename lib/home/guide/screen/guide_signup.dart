import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart'; // Import Cloudinary package
import 'package:travel_guide/home/guide/service/guidefirebaseauthservice.dart';
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';

class GuideSignup extends StatefulWidget {
  const GuideSignup({super.key});

  @override
  State<GuideSignup> createState() => _GuideSignupState();
}

class _GuideSignupState extends State<GuideSignup> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Emailaddress = TextEditingController();
  TextEditingController Phone_number = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();
  TextEditingController License = TextEditingController();
  bool show = true;

  // Cloudinary configuration
  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: 'db2nki9dh',  // Replace with your Cloudinary cloud name
    apiKey: '894239764992456',  // Replace with your API key
    apiSecret: 'YDHnglB1cOzo4FSlhoQmSzca1e0',  // Replace with your API secret
  );

  XFile? _image;  // Store the picked image/file

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    Emailaddress.dispose();
    Phone_number.dispose();
    confirmpassword.dispose();
    aadharNumber.dispose();
    License.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<String?> _uploadFileToCloudinary(XFile file) async {
    try {
      // Upload file to Cloudinary
      var response = await cloudinary.upload(
        file: file.path, 
        folder: 'license_photos', // Path to the file
        resourceType: CloudinaryResourceType.image,  // Adjust according to file type
      );
      print('File uploaded to Cloudinary: ${response.secureUrl}');
      return response.secureUrl;  // Return the secure URL
    } catch (e) {
      print('Error uploading file: $e');
      return null;  // Return null in case of error
    }
  }

  void Registerguide() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Proceed with Cloudinary file upload if an image is selected
      String? imageUrl = '';
      if (_image != null) {
        imageUrl = await _uploadFileToCloudinary(_image!);  // Upload image to Cloudinary and get URL
      }

      // After file upload, continue with the registration logic
      if (imageUrl != null) {
        Guidefirebaseauthservice().guideRegister(
          email: Emailaddress.text,
          username: username.text,
          Phone_number: Phone_number.text,
          password: password.text,
          aadhar: aadharNumber.text,
          License: License.text,
          licenseImageUrl: imageUrl, // Pass the license image URL to the guideRegister function
          context: context,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const GuideHomepage();
            },
          ),
        );
      } else {
        // Handle the case where image URL is null
        print('Image upload failed or no image selected');
      }
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  'asset/logo3.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 20),
              
              // Username field
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Email field
              TextFormField(
                controller: Emailaddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
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
              const SizedBox(height: 10),

              // Phone number field
              TextFormField(
                controller: Phone_number,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
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
              const SizedBox(height: 10),

              // Aadhar Number field
              TextFormField(
                controller: aadharNumber,
                decoration: InputDecoration(
                  labelText: 'Aadhar Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Aadhar Number';
                  } else if (value.length != 12) {
                    return 'Aadhar number must be 12 digits';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Aadhar number can only contain digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // License Number field
              TextFormField(
                controller: License,
                decoration: InputDecoration(
                  labelText: 'License Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your License Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Password field
              TextFormField(
                controller: password,
                obscureText: show,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        show = !show;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Confirm Password field
              TextFormField(
                controller: confirmpassword,
                obscureText: show,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != password.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Upload File Button
              ElevatedButton(
                onPressed: _pickDocument,
                child: const Text('Upload License'),
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: Registerguide,  // Trigger form submission
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
