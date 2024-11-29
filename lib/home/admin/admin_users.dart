import 'package:flutter/material.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  // Sample data for users
  List<Map<String, String>> users = [
    {'name': 'John Doe', 'gender': 'Male', 'image': 'assets/images/john_doe.jpg'},
    {'name': 'Jane Smith', 'gender': 'Female', 'image': 'assets/images/jane_smith.jpg'},
    {'name': 'Alex Green', 'gender': 'Other', 'image': 'assets/images/alex_green.jpg'},
    {'name': 'Michael Brown', 'gender': 'Male', 'image': 'assets/images/michael_brown.jpg'},
    {'name': 'Emily White', 'gender': 'Female', 'image': 'assets/images/emily_white.jpg'},
  ];

  String selectedGender = 'All'; // Default gender filter (All)

  // Filter users by gender
  List<Map<String, String>> getFilteredUsers() {
    if (selectedGender == 'All') {
      return users;
    } else {
      return users.where((user) => user['gender'] == selectedGender).toList();
    }
  }

  // Show Gender Filter Dialog
  void showGenderFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['All', 'Male', 'Female', 'Other'].map((gender) {
              return RadioListTile<String>(
                title: Text(gender),
                value: gender,
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                    Navigator.pop(context);
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Show Search Dialog
  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Users'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter name to search...',
            ),
            onChanged: (query) {
              setState(() {
                // Implement search functionality here
                // This is just a placeholder for actual search logic.
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Navigate to a user-specific page
  void navigateToUserDetails(Map<String, String> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user), // Pass user data to the details page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Users'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Button (Outside AppBar)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: showSearchDialog,
            ),
            // Filter Button
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: showGenderFilterDialog,
            ),
            // List of filtered users displayed in cards
            Expanded(
              child: ListView(
                children: [
                  // Display cards for filtered users
                  ...getFilteredUsers().map((user) {
                    return GestureDetector(
                      onTap: () => navigateToUserDetails(user), // Navigate to user details page
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(user['image']!),
                              ),
                              const SizedBox(width: 16), // Space between image and text
                              // User Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// User Details Page
class UserDetailsPage extends StatelessWidget {
  final Map<String, String> user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name']!),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(user['image']!),
            ),
            const SizedBox(height: 16),
            // User Name
            Text(
              user['name']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // User Gender
            Text(
              'Gender: ${user['gender']}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
