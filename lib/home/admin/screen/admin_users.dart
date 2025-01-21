import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get users data from Firestore without gender filter
  Stream<QuerySnapshot> getUserStream() {
    var userCollection = _firestore.collection('Users');
    return userCollection
        .snapshots(); // Get all users without filtering by gender
  }

  // Navigate to the user details page
  void navigateToUserDetails(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user),
      ),
    );
  }

  // Delete User from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to delete user')));
    }
  }

  // Show confirmation dialog before deleting
  void showDeleteConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteUser(userId); // Delete user if confirmed
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Users'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        // Adding a linear gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: getUserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Users found'));
            }

            var users = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index].data() as Map<String, dynamic>;
                String userId = users[index].id; // Get the user ID

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => navigateToUserDetails(user),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.green, // Green card background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // If the image is null or empty, show account icon
                            user['image'] != null && user['image'].isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(user['image']),
                                  )
                                : Icon(
                                    Icons
                                        .account_circle, // Account icon as fallback
                                    size: 60, // Icon size
                                    color: Colors.black, // Icon color
                                  ),
                            const SizedBox(width: 16),
                            // Display user name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? 'No name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Font color black
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Delete Icon
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  showDeleteConfirmationDialog(userId),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user['name']} Details'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Display the user's name in a tile
              _buildTile('Name', user['name'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Date of Birth in a tile
              _buildTile('Date of Birth', user['DOB'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Email in a tile
              _buildTile('Email', user['useremail'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Address in a tile
              _buildTile('Address', user['address'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display City in a tile
              _buildTile('City', user['city'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display State in a tile
              _buildTile('State', user['state'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Pincode in a tile
              _buildTile('Pincode', user['pincode'] ?? 'Not Available'),
              const SizedBox(height: 10),
              // Display Nation in a tile
              _buildTile('Nation', user['nation'] ?? 'Not Available'),
              const SizedBox(height: 20),
              // Display the user's profile image or placeholder icon
              user['image'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        user['image'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.blueGrey[100],
                      child: const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a tile for user details
  Widget _buildTile(String title, String value) {
    return Card(
      color: const Color.fromARGB(255, 39, 39, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
