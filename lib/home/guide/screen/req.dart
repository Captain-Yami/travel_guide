import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/screen/RequestDetailsPage.dart';
import 'package:travel_guide/home/guide/screen/BookingDetailsPage.dart';

class GuideDashboard extends StatefulWidget {
  const GuideDashboard({super.key});

  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

class _GuideDashboardState extends State<GuideDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> requests = [];
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchRequests();
    _fetchBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchRequests() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('requests').get();

      setState(() {
        requests = snapshot.docs.map((doc) => _parseRequestData(doc)).toList();
      });
    } catch (e) {
      print('Error fetching requests: $e');
    }
  }

  Future<void> _fetchBookings() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('confirmed_requests').get();

      setState(() {
        bookings = snapshot.docs.map((doc) => _parseBookingData(doc)).toList();
      });
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  Map<String, dynamic> _parseRequestData(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return {
      'id': doc.id,
      'name': data['userName'] ?? 'Unknown User',
      'details': data['aboutTrip'] ?? '',
      'categories': _parseList(data['categories']),
      'places': _parseList(data['places']),
      'status': data['status'] ?? 'Pending',
      'image': 'assets/background3.jpg',
      'user': data['user'] ?? '',
    };
  }

  Map<String, dynamic> _parseBookingData(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return {
      'id': doc.id,
      'name': data['userName'] ?? 'Unknown User',
      'details': data['tripDetails'] ?? '',
      'places': _parseList(data['places']),
      'image': 'assets/background3.jpg',
    };
  }

  List<String> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is String) {
      return data.split(',').map((e) => e.trim()).toList();
    }
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }

    // Callback method to remove confirmed request from the list
  void _removeConfirmedRequest(String requestId) {
    setState(() {
      requests.removeWhere((request) => request['id'] == requestId);
    });
  }

   // Callback method to remove confirmed/declined request from the list
  void _removeRequest(String requestId) {
    setState(() {
      requests.removeWhere((request) => request['id'] == requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(255, 200, 200, 200),
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(context),
          _buildBookingList(context),
        ],
      ),
    );
  }

  Widget _buildRequestList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(request['image']),
              radius: 30,
            ),
            title: Text(request['name']),
            subtitle: Text(request['details']),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailsPage(
                      requestId: request['id'],
                      name: request['name'],
                      image: request['image'],
                      placesToVisit: List<String>.from(request['places']),
                      interestedCategories: List<String>.from(request['categories']),
                      details: request['details'],
                      user: request['user'],
                      onConfirm: () => _removeConfirmedRequest(request['id']),   // Pass the callback here
                      onDecline: () => _removeRequest(request['id']),  // Callback for Decline
                    ),
                  ),
                );
              },
              child: const Text('View'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingList(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.all(8.0),
    itemCount: bookings.length,
    itemBuilder: (context, index) {
      final booking = bookings[index];
      
      // Assuming you want to get the corresponding requestId based on the booking data.
      // If requestId is available in the booking data, use that. 
      // Otherwise, fetch or set it accordingly.
      final String requestId = booking['id'];  // or fetch from Firestore if needed
      
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(booking['image']),
            radius: 30,
          ),
          title: Text(booking['name']),
          subtitle: Text(booking['details']),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsPage(
                    name: booking['name'],
                    image: booking['image'],
                    requestId: requestId,  // Ensure requestId is passed here
                    places: List<String>.from(booking['places']),  // Pass places here
                  ),
                ),
              );
            },
            child: const Text('View'),
          ),
        ),
      );
    },
  );
}
    }