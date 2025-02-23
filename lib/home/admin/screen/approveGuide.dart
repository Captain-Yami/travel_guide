import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GuideApproval extends StatefulWidget {
  const GuideApproval({super.key});

  @override
  State<GuideApproval> createState() => GuideApprovalState();
}

class GuideApprovalState extends State<GuideApproval>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // vsync is provided by the mixin
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Management',
            style: TextStyle(color: Colors.green)), // Font color in Green
        backgroundColor: Colors.black, // AppBar background color
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accept'),
            Tab(text: 'Reject'),
          ],
          labelColor: Colors.green, // Tab font color in Green
          unselectedLabelColor:
              Colors.white, // Unselected tab font color in White
          indicatorColor: Colors.green, // Tab indicator color in Green
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPendingTab(), // Pending Tab - Show data where 'isApproved' is false
            _buildAcceptTab(), // Accept Tab - Show data where 'isApproved' is true
            _buildRejectTab(),
          ],
        ),
      ),
    );
  }

  // Pending Tab: Show hotels with 'isApproved' is false
  Widget _buildPendingTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Guide')
          .where('isApproved', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending guides.'));
        }

        final hotels = snapshot.data!.docs;
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotelData = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;
            final hotelName = hotelData['name'] ?? 'No Name';
            final contactEmail = hotelData['gideemail'] ?? 'N/A';
            final contactNumber = hotelData['phone number'] ?? 'N/A';
            final License = hotelData['License'] ?? 'N/A';
            final location = hotelData['aadhar'] ?? 'No Location';
            final imageUrl = hotelData['profile_picture'] ?? 'N/A';
            final document = hotelData['licenseImageUrl'] ?? 'N/A';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green, // Card color in Green
              child: ExpansionTile(
                title: Text(hotelName,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                subtitle: Text(location,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                children: [
                  ListTile(
                    title: const Text('Contact Email:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactEmail,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Contact Number:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactNumber,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('License:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(License,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('aadhar:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('profile image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('License image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => _updateApprovalStatus(hotelId, true),
                        child: const Text('Accept',
                            style: TextStyle(color: Color.fromARGB(255, 1, 32, 59))),
                      ),
                      TextButton(
                        onPressed: () => _updateApprovalStatus(hotelId, false),
                        child: const Text('Reject',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Accept Tab: Show hotels with 'isApproved' is true
  Widget _buildAcceptTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Guide')
          .where('isApproved', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No accepted hotels.'));
        }

        final hotels = snapshot.data!.docs;
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotelData = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;
            final hotelName = hotelData['name'] ?? 'No Name';
            final contactEmail = hotelData['gideemail'] ?? 'N/A';
            final contactNumber = hotelData['phone number'] ?? 'N/A';
            final License = hotelData['License'] ?? 'N/A';
            final location = hotelData['aadhar'] ?? 'No Location';
            final imageUrl = hotelData['profile_picture'] ?? 'N/A';
            final document = hotelData['licenseImageUrl'] ?? 'N/A';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green, // Card color in Green
              child: ExpansionTile(
                title: Text(hotelName,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                subtitle: Text(location,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                children: [
                  ListTile(
                    title: const Text('Contact Email:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactEmail,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Contact Number:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactNumber,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('License:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(License,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Aadhar:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('Profile Image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('License image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Reject Tab: Show hotels with 'isApproved' is false
  Widget _buildRejectTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Guide')
          .where('isApproved', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No rejected hotels.'));
        }

        final hotels = snapshot.data!.docs;
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotelData = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;
            final hotelName = hotelData['name'] ?? 'No Name';
            final contactEmail = hotelData['gideemail'] ?? 'N/A';
            final contactNumber = hotelData['phone number'] ?? 'N/A';
            final License = hotelData['License'] ?? 'N/A';
            final location = hotelData['aadhar'] ?? 'No Location';
            final imageUrl = hotelData['profile_picture'] ?? 'N/A';
            final document = hotelData['licenseImageUrl'] ?? 'N/A';
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green, // Card color in Green
              child: ExpansionTile(
                title: Text(hotelName,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                subtitle: Text(location,
                    style:
                        TextStyle(color: Colors.black)), // Font color in Black
                children: [
                  ListTile(
                    title: const Text('Contact Email:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactEmail,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Contact Number:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(contactNumber,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('License:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(License,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Aadhar:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('profile Image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('License image:',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Method to update the approval status of the hotel
  Future<void> _updateApprovalStatus(String hotelId, bool isApproved) async {
    try {
      await FirebaseFirestore.instance
          .collection('Guide')
          .doc(hotelId)
          .update({'isApproved': isApproved});
      String status = isApproved ? 'accepted' : 'rejected';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Guide has been $status successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
