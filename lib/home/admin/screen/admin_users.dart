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
  void navigateToUserDetails(Map<String, dynamic> user, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: user, userId: userId),
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
                    onTap: () => navigateToUserDetails(user, userId),
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
  final String userId;

  const UserDetailsPage({super.key, required this.user, required this.userId});

  // Suspend the user with a reason
 Future<void> suspendUser(BuildContext context) async {
  TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Suspend User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for suspending this user:'),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Enter reason here'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String reason = reasonController.text.trim();
              if (reason.isNotEmpty) {
                try {
                  // Suspend the user in the Users collection
                  await FirebaseFirestore.instance.collection('Users').doc(userId).update({
                    'status': true,  // Set user as suspended
                    'suspensionReasons': FieldValue.arrayUnion([reason]), // Add reason to the list
                  });

                  // Update or create the suspend document for the user
                  await FirebaseFirestore.instance.collection('suspend').doc(userId).set({
                    'useremail': user['useremail'], // Store user email
                    'status': true,  // Set user status as suspended
                    'id': userId, // Store user ID
                    'reason': FieldValue.arrayUnion([reason]), // Add suspension reason to list
                    'timestamp': FieldValue.serverTimestamp(), // Optional: track when the suspension happened
                  }, SetOptions(merge: true)); // If the document exists, merge the updates

                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User suspended successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred while suspending the user.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason.')),
                );
              }
            },
            child: const Text('Suspend'),
          ),
        ],
      );
    },
  );
}


  // Revoke the suspension of the user
  Future<void> revokeSuspension(BuildContext context) async {
  try {
    // Fetch the current user status first
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      bool isSuspended = userDoc['status'] ?? false; // Fetch the status of the user

      if (isSuspended) {
        // Update the user's status in the 'Users' collection to false (revoked)
        await FirebaseFirestore.instance.collection('Users').doc(userId).update({
          'status': false,  // Revoke the suspension (set status to false)
        });

        // Update the status in the 'suspend' collection
        await FirebaseFirestore.instance.collection('suspend').doc(userId).update({
          'status': false, // Mark status as revoked
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Suspension revoked successfully')),
        );
      } else {
        // If the user is already not suspended, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The user is not suspended.')),
        );
      }
    } else {
      // Handle the case when the user document does not exist
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while revoking the suspension.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    bool isSuspended =
        user['status'] ?? false; // Check if the user is suspended

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
              _buildTile('Name', user['name'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Date of Birth', user['DOB'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Email', user['useremail'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Address', user['address'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('City', user['city'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('State', user['state'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Pincode', user['pincode'] ?? 'Not Available'),
              const SizedBox(height: 10),
              _buildTile('Nation', user['nation'] ?? 'Not Available'),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => suspendUser(context),
            backgroundColor: Colors.orange,
            child: const Icon(Icons.lock, color: Colors.white),
            tooltip: 'Suspend User',
          ),
          const SizedBox(height: 10),
          // Only show the Revoke Suspension button if the user is suspended (status == true)
          if (isSuspended)
            FloatingActionButton(
              heroTag: null,
              onPressed: () => revokeSuspension(context),
              backgroundColor: Colors.green,
              child: const Icon(Icons.lock_open, color: Colors.white),
              tooltip: 'Revoke Suspension',
            ),
        ],
      ),
    );
  }

  // Helper method to create a tile for user details
  Widget _buildTile(String title, String subtitle) {
    return Card(
      color: const Color.fromARGB(255, 39, 39, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.green, fontSize: 16),
        ),
      ),
    );
  }
}
