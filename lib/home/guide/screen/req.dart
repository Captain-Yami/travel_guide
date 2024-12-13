import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/userchat.dart';

class UserChatModel {
  final String name;
  final String profilePic;
  final String lastMessage;
  final String messageTime;

  UserChatModel({
    required this.name,
    required this.profilePic,
    required this.lastMessage,
    required this.messageTime,
  });
}

class GuideDashboard extends StatefulWidget {
  const GuideDashboard({super.key});

  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

class _GuideDashboardState extends State<GuideDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Dummy data for requests and bookings
  List<Map<String, dynamic>> requests = [
    {
      'name': 'Sairaj',
      'image': 'asset/background3.jpg',
      'status': 'Pending',
      'details': 'Looking for a local guide for city exploration.',
      'categories': ['Historical', 'Adventure'],
      'places': ['Mumbai', 'Gateway of India'],
    },
    {
      'name': 'Rhidu',
      'image': 'asset/background3.jpg',
      'status': 'Pending',
      'details': 'Interested in nature trails and photography.',
      'categories': ['Nature', 'Photography'],
      'places': ['Munnar', 'Kumarakom'],
    },
  ];

  List<Map<String, dynamic>> bookings = [
    {
      'name': 'Alice',
      'image': 'asset/background3.jpg',
      'status': 'Confirmed',
      'details': 'Day trip to the beach.',
      'categories': ['Relaxation'],
      'places': ['Goa'],
    },
    {
      'name': 'John',
      'image': 'asset/background3.jpg',
      'status': 'Confirmed',
      'details': 'Local food tour.',
      'categories': ['Food'],
      'places': ['Chennai'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor:   const Color.fromARGB(255, 200, 200, 200),
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Requests Tab
          _buildRequestList(context),
          // Bookings Tab
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
                      name: request['name'],
                      image: request['image'],
                      placesToVisit: request['places'],
                      interestedCategories: request['categories'],
                      details: request['details'],
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

// Page to show request details
class RequestDetailsPage extends StatelessWidget {
  final String name;
  final String image;
  final List<String> placesToVisit;
  final List<String> interestedCategories;
  final String details;

  const RequestDetailsPage({
    required this.name,
    required this.image,
    required this.placesToVisit,
    required this.interestedCategories,
    required this.details,
  });

  // Function to handle confirmation
  void handleConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request for $name has been confirmed!')),
    );
    Navigator.pop(context);
  }

  // Function to decline the request
  void handleDecline(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request from $name has been declined.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Request Details',
           style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Status: Pending',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 10, 10, 10)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Details Section
            const Text(
              'Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(details),
            const SizedBox(height: 16),

            // Categories Section
            const Text(
              'Interested Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(interestedCategories.join(', ')),
            const SizedBox(height: 16),
            // Places Section
            const Text(
              'Places to Visit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(placesToVisit.join(', ')),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleConfirmation(context),
                  child: const Text('Confirm',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => handleDecline(context),
                  child: const Text('Decline',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chat Button
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChat(
                      name: name,
                      profilePic: image,
                      lastMessage: 'Hello, I need assistance with my trip.',
                      messageTime: '2:45 PM',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat),
              label: const Text('Chat with User',style: TextStyle(color: Colors.black),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
              ),
            ),
          ],
        ),
        ],
            ),
      ),
    );
  }
} 
// Page to show booking details
class BookingDetailsPage extends StatelessWidget {
  final String name;
  final String image;

  const BookingDetailsPage({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Booking Details',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Status: Confirmed',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 11, 11, 11)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Booking Summary Section
            const Text(
              'Booking Summary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tour Date: 15th Dec 2024'),
            const SizedBox(height: 4),
            const Text('Payment Status: Paid'),
            const SizedBox(height: 16),

            // Places Section
            const Text(
              'Itinerary:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Gateway of India'),
            const Text('2. Marine Drive'),
            const Text('3. Elephanta Caves'),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cancel Booking Action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking cancelled successfully.')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel Booking',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 30,
                    ),
                  ),
                ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChat(
                      name: name,
                      profilePic: image,
                      lastMessage: 'Looking forward to our trip!',
                      messageTime: 'Yesterday',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat),
              label: const Text('Chat with User',style: TextStyle(color: Colors.black),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(vertical:14,horizontal: 30),
              ),
            ),
          ],
        ),
        ],
       ),
      ),
    );
  }
}