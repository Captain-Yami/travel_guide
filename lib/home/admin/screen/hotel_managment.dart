import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HotelManagment extends StatefulWidget {
  const HotelManagment({super.key});

  @override
  State<HotelManagment> createState() => _HotelManagmentState();
}

class _HotelManagmentState extends State<HotelManagment>
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
        title: const Text('Hotel Management',
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
          .collection('hotels')
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
          return const Center(child: Text('No pending hotels.'));
        }

        final hotels = snapshot.data!.docs;
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotelData = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;
            final hotelName = hotelData['hotelName'] ?? 'No Name';
            final contactEmail = hotelData['contactEmail'] ?? 'N/A';
            final contactNumber = hotelData['contactNumber'] ?? 'N/A';
            final facilities = hotelData['facilities'] ?? 'N/A';
            final location = hotelData['location'] ?? 'No Location';
            final imageUrl = hotelData['imageUrl'] ?? 'N/A';
            final document = hotelData['document'] ?? 'N/A';

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
                    title: const Text('Facilities:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(facilities,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Location:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('Hotel Image',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('Hotel Document',
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
          .collection('hotels')
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
            final hotelName = hotelData['hotelName'] ?? 'No Name';
            final contactEmail = hotelData['contactEmail'] ?? 'N/A';
            final contactNumber = hotelData['contactNumber'] ?? 'N/A';
            final facilities = hotelData['facilities'] ?? 'N/A';
            final location = hotelData['location'] ?? 'No Location';
            final imageUrl = hotelData['imageUrl'] ?? 'N/A';
            final document = hotelData['document'] ?? 'N/A';

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
                    title: const Text('Facilities:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(facilities,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Location:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('Hotel Image',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('Hotel Document',
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
          .collection('hotels')
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
            final hotelName = hotelData['hotelName'] ?? 'No Name';
            final contactEmail = hotelData['contactEmail'] ?? 'N/A';
            final contactNumber = hotelData['contactNumber'] ?? 'N/A';
            final facilities = hotelData['facilities'] ?? 'N/A';
            final location = hotelData['location'] ?? 'No Location';
            final imageUrl = hotelData['imageUrl'] ?? 'N/A';
            final document = hotelData['document'] ?? 'N/A';

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
                    title: const Text('Facilities:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(facilities,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  ListTile(
                    title: const Text('Location:',
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                    subtitle: Text(location,
                        style: TextStyle(
                            color: Colors.black)), // Font color in Black
                  ),
                  if (imageUrl.isNotEmpty)
                    ListTile(
                      leading: Image.network(imageUrl),
                      title: const Text('Hotel Image',
                          style: TextStyle(
                              color: Colors.black)), // Font color in Black
                    ),
                  if (document.isNotEmpty)
                    ListTile(
                      leading: Image.network(document),
                      title: const Text('Hotel Document',
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
          .collection('hotels')
          .doc(hotelId)
          .update({'isApproved': isApproved});
      String status = isApproved ? 'accepted' : 'rejected';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel has been $status successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
