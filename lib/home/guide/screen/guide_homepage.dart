import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/activities.dart';
import 'package:travel_guide/home/guide/screen/availability.dart';
import 'package:travel_guide/home/guide/chats.dart';
import 'package:travel_guide/home/guide/screen/guide_profile.dart';
import 'package:travel_guide/home/guide/notifications.dart';
import 'package:travel_guide/home/guide/screen/req.dart';
import 'package:travel_guide/home/guide/screen/availability.dart';
import 'package:travel_guide/home/guide/screen/availability.dart';
import 'package:travel_guide/home/guide/screen/guide_profile.dart';
import 'package:travel_guide/home/guide/screen/req.dart';
import 'package:travel_guide/home/start.dart';
import 'package:travel_guide/home/user/screen/Recent.dart';
import 'package:travel_guide/home/user/screen/User_profile.dart';
import 'package:travel_guide/home/user/screen/favorites.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';


class GuideHomepage extends StatefulWidget {
  const GuideHomepage({super.key});

  @override
  State<GuideHomepage> createState() => _MainPageState();
}

class _MainPageState extends State<GuideHomepage> {
  final _searchcontroller = TextEditingController();
  int _selectedIndex = 0;
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex); // Initialize PageController
  }

  // Navigation functions for each page
  void _navigateToreq() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuideDashboard()), // Replace with actual destination widget
    );
  }

  void _navigateToAvailability() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Availability()), // Replace with actual destination widget
    );
  }

  // Page navigation for BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 300), // Duration for the slide animation
      curve: Curves.ease, // You can change this for different effects
    );
  }

  void _showChangePasswordDialog() {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final currentPassword = currentPasswordController.text;
              final newPassword = newPasswordController.text;
              final confirmPassword = confirmPasswordController.text;

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match!')),
                );
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null && user.email != null) {
                  // Reauthenticate the user
                  final credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );

                  await user.reauthenticateWithCredential(credential);

                   // Update the password in Firebase Authentication
                  await user.updatePassword(newPassword);

                  // Update the password in the Guide collection
                   final guideId = user.uid;
                  await FirebaseFirestore.instance
                      .collection('Guide')
                      .doc(guideId)
                      .update({'password': newPassword});


                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No user is signed in.')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Change Password'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showPrivacySettingsDialog(BuildContext context, String guideId) {
  bool shareContactInfo = true;
  bool allowChat = true;

  void _deleteAccount(BuildContext context, String guideId) async {
    try {
      // Delete the guide's document from Firestore
      await FirebaseFirestore.instance.collection('Guide').doc(guideId).delete();

      // Delete the guide's authentication account
      await FirebaseAuth.instance.currentUser?.delete();

      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pop(); // Navigate back to login screen

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );

      // Navigate to login page (replace with your login page widget)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Privacy Settings'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Data Sharing Preferences
                  SwitchListTile(
                    title: const Text('Share Contact Information'),
                    value: shareContactInfo,
                    onChanged: (value) {
                      setState(() => shareContactInfo = value);
                      FirebaseFirestore.instance
                          .collection('Guide')
                          .doc(guideId)
                          .update({'shareContact': value});
                    },
                  ),
                  // Communication Preferences
                  SwitchListTile(
                    title: const Text('Allow Chat Requests'),
                    value: allowChat,
                    onChanged: (value) {
                      setState(() => allowChat = value);
                      FirebaseFirestore.instance
                          .collection('Guide')
                          .doc(guideId)
                          .update({'allowChat': value});
                    },
                  ),
                  // Delete Account
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                'Are you sure you want to delete your account? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => _deleteAccount(context, guideId),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Settings Updated')),
                  );
                },
                child: const Text('Save Settings'),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController to avoid memory leaks
    super.dispose();
  }

   Future<void> handleMenuSelection(String option) async {
    switch (option) {
      case 'Change Password':
        _showChangePasswordDialog();
        
        break;                                         
      case 'Privacy Settings':
         final guideId = FirebaseAuth.instance.currentUser?.uid; // Replace with actual guide ID
  if (guideId != null) {
    _showPrivacySettingsDialog(context, guideId);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error: Guide ID not found')),
    );
  }
      break;
      case 'Logout':
  try {
    // Log out the user from Firebase Authentication
    await FirebaseAuth.instance.signOut();

    // Show the logout confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );

    // Navigate to the login page after logging out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
    );
  } catch (e) {
    // Handle any errors that occur during the logout process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error logging out: $e')),
    );
  }
  break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 251, 249, 251),
              const Color.fromARGB(255, 251, 249, 251)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            _buildHomePage(),
            const Activities(),
            const Chats(),
            const GuideProfile(isEditing: false),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.access_time, 1),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.chat, 2),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.account_circle, 3),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        unselectedItemColor: const Color.fromARGB(255, 6, 6, 6),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        showSelectedLabels: true,  // Show labels for selected items
        showUnselectedLabels: true,  // Show labels for unselected items
      ),
    );
  }
  
  // Dynamically build AppBar based on the selected index
AppBar _buildAppBar() {
  String title = '';
  double logoTextSpacing = 20.0; // Default spacing

  List<Widget> appBarActions = []; // Store dynamic actions for the AppBar

  // Set the title, logo-text spacing, and appBar actions based on selected index
  switch (_selectedIndex) {
    case 0: // Home Page
      title = 'Travel Chronicles';
      logoTextSpacing = 120.0; // Normal space
      appBarActions = [
        IconButton(
          icon: const Icon(Icons.notifications_active),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notifications()), // Replace with actual destination widget
            );
          },
        ),
      ];
      break;
    case 2: // Chats
      title = 'Chats';
      logoTextSpacing = 165.0; // Larger space for Chats
      appBarActions = [
        PopupMenuButton<String>(
          onSelected: handleMenuSelection,
          icon: const Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: 'Mark all as unread',
                child: Text('Mark all as unread'),
              ),
              const PopupMenuItem(
                value: 'Chat Settings',
                child: Text('Chat Settings'),
              ),
              const PopupMenuItem(
                value: 'Search Chats',
                child: Text('Search Chats'),
              ),
            ];
          },
        ),
      ];
      break;
    case 3: // Profile
      title = 'Profile';
      logoTextSpacing = 165.0; // Smaller space for Profile
      appBarActions = [
        PopupMenuButton<String>(
          onSelected: handleMenuSelection,
          icon: const Icon(Icons.settings, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: 'Change Password',
                child: Text('Change Password'),
              ),
              const PopupMenuItem(
                value: 'Privacy Settings',
                child: Text('Privacy Settings'),
              ),
              const PopupMenuItem(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ];
          },
        ),
      ];
      break;
    default:
      title = 'Travel Chronicles';
      logoTextSpacing = 120.0;
      break;
  }

  return AppBar(
    backgroundColor: const Color.fromARGB(255, 42, 41, 41),
    title: null, // Set title to null as we will use flexibleSpace to center everything
    flexibleSpace: Container(
      height: 200, // Make sure the flexible space matches the AppBar height
      alignment: Alignment.bottomCenter, // Align everything to the bottom
      padding: const EdgeInsets.only(bottom: 0), // Adjust the padding to push content down closer to the bottom line
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between logo, title, and actions
        children: [
          // Logo with left padding for space
          Padding(
            padding: const EdgeInsets.only(left: 20.0), // Add space to the left of the logo
            child: ClipOval(
              child: Image.asset(
                'asset/logo3.jpg', // Replace with your logo path
                fit: BoxFit.cover,
                height: 40,
                width: 40, // Make the width and height equal for a perfect circle
              ),
            ),
          ),
          // Title in the center
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 253, 253, 253),
                ),
              ),
            ),
          ),
          // Action button(s) with right padding for space
          Padding(
            padding: const EdgeInsets.only(right: 20.0), // Add space to the right of the action buttons
            child: Row(
              children: appBarActions,
            ),
          ),
        ],
      ),
    ),
  );
}






  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ 
                  SizedBox(height: 20),
                  Container(
                    width: 400, // Set the width of the TextFormField
                    height: 60, // Set the height of the TextFormField
                    child: TextFormField(
                      controller: _searchcontroller,
                      decoration: InputDecoration(
                        hintText: 'Search', // Optional hint text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Oval shape
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 5, 0, 0),
                            width: 2, // Border color and thickness
                          ),
                        ),
                        suffixIcon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 1, 2, 3)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20), // Padding to adjust the internal space
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Requests & Booking" Button
          Container(
            width: 400,
            height: 150,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _navigateToreq,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   const SizedBox(width: 30),
                  Image.asset(
                    'asset/req_icon.png', // Path to your custom image asset
                    width: 70, // Set the width of the icon
                    height: 70, // Set the height of the icon
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Requests & Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 5, 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Start your journey" button
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ 
                  Container(
                    width: 400, // Set the width of the TextFormField
                    height: 200, // Set the height of the TextFormField
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.3, // Square aspect ratio (width == height)
                      children: [
                        // Button 1: Place
                        _buildGridButton(
                          icon: Icons.event_available,
                          label: 'Availability',
                          onPressed: _navigateToAvailability,
                        ),
                        // Button 2: Guide
                        _buildGridButton(
                          icon: Icons.star,
                          label: 'Ratings',
                          onPressed: _navigateToreq,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 150, // Adjust width of container
      height: 150, // Adjust height of container
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240), // Set button color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color.fromARGB(255, 8, 8, 8)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    double iconSize = _selectedIndex == index ? 30.0 : 24.0; // Increase size for selected icon
    return Icon(
      icon,
      size: iconSize,
      color: const Color.fromARGB(255, 6, 6, 6),
    );
  }
}