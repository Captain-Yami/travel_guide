import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final guideId = FirebaseAuth.instance.currentUser?.uid;
    if (guideId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guide not logged in.')),
        );
      }
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('guideId', isEqualTo: guideId)
        .get();

    if (mounted) {
      setState(() {
        requests = snapshot.docs.map((doc) => _parseRequestData(doc)).toList();
      });
    }
  } catch (e) {
    print('Error fetching requests: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch requests.')),
      );
    }
  }
}

Future<void> _fetchBookings() async {
  try {
    final guideId = FirebaseAuth.instance.currentUser?.uid;
    if (guideId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guide not logged in.')),
        );
      }
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('confirmed_requests')
        .where('guideId', isEqualTo: guideId)
        .get();

    if (mounted) {
      setState(() {
        bookings = snapshot.docs.map((doc) => _parseBookingData(doc)).toList();
      });
    }
  } catch (e) {
    print('Error fetching bookings: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch bookings.')),
      );
    }
  }
}

  void _removeRequest(String requestId) {
    setState(() {
      requests.removeWhere((request) => request['id'] == requestId);
    });
    // Refresh bookings as a confirmed request may be added here
    _fetchBookings();
  }

  Map<String, dynamic> _parseRequestData(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return {
      'guideId': data['guideId'] ?? '',
      'id': doc.id,
      'name': data['userName'] ?? 'Unknown User',
      'details': data['aboutTrip'] ?? '',
      'categories': _parseList(data['categories']),
      'places': _parseList(data['places']),
      'status': data['status'] ?? 'Pending',
      'image': data['userProfilePic'] ??'asset/background3.jpg',
      'user': data['user'] ?? '',
    };
  }

  Map<String, dynamic> _parseBookingData(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return {
      'guideId': data['guideId'] ?? '',
      'id': doc.id,
      'name': data['userName'] ?? 'Unknown User',
      'details': data['aboutTrip'] ?? '',
      'places': _parseList(data['places']),
      'image': data['userProfilePic'] ??'asset/background3.jpg',
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
                      guideId: request['guideId'],
                      requestId: request['id'],
                      name: request['name'],
                      image: request['image'],
                      placesToVisit: List<String>.from(request['places']),
                      interestedCategories: List<String>.from(request['categories']),
                      details: request['details'],
                      user: request['user'],
                      onRemoveRequest: _removeRequest, // Pass callback
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
      final String requestId = booking['id'];

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
                    guideId: booking['guideId'],
                    name: booking['name'],
                    image: booking['image'],
                    requestId: requestId,
                    places: List<String>.from(booking['places']),
                    onRemoveBooking: (String id) {
                      setState(() {
                        bookings.removeWhere((booking) => booking['id'] == id);
                      });
                    },
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