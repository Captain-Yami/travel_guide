import 'package:flutter/material.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  // Sample data for users (unchanged)
  List<Map<String, String>> users = [
    {'name': 'John Doe', 'gender': 'Male', 'image': 'assets/images/john_doe.jpg'},
    {'name': 'Jane Smith', 'gender': 'Female', 'image': 'assets/images/jane_smith.jpg'},
    {'name': 'Alex Green', 'gender': 'Other', 'image': 'assets/images/alex_green.jpg'},
    {'name': 'Michael Brown', 'gender': 'Male', 'image': 'assets/images/michael_brown.jpg'},
    {'name': 'Emily White', 'gender': 'Female', 'image': 'assets/images/emily_white.jpg'},
  ];

  String selectedGender = 'All'; // Default gender filter (All)

  // Filter users by gender (unchanged)
  List<Map<String, String>> getFilteredUsers() {
    if (selectedGender == 'All') {
      return users;
    } else {
      return users.where((user) => user['gender'] == selectedGender).toList();
    }
  }

  // Show Gender Filter Dialog (unchanged)
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

  // Show Search Dialog (unchanged)
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

  // Navigate to a user-specific page (redirect to CardDetailsPage now)
  void navigateToCardDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailsPage(cardNumber: index + 1), // Pass card number
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
                  // Display cards for filtered users, now labeled as Card 1, Card 2, etc.
                  ...getFilteredUsers().asMap().entries.map((entry) {
                    int index = entry.key;
                    var user = entry.value;
                    return GestureDetector(
                      onTap: () => navigateToCardDetails(index), // Navigate to card details
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
                              // Card Number as label
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Card ${index + 1}', // Display card number
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

// New Page for Card Details
class CardDetailsPage extends StatelessWidget {
  final int cardNumber;

  const CardDetailsPage({super.key, required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Details - $cardNumber'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the card number
            Text(
              'Details for Card $cardNumber',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Optionally, you can add more details here as needed
            Text(
              'This is where the details for Card $cardNumber would go.',
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
