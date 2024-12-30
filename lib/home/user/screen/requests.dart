import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'asset/logo3.jpg',
                fit: BoxFit.cover,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 120),
            const Text(
              'Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 251, 250, 250),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Accept'),
            Tab(text: 'Reject'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAcceptTabContent(),
          _buildTabContent('Reject', 'This is the Reject tab content'),
        ],
      ),
    );
  }

  Widget _buildAcceptTabContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('confirmed_requests')
          .where('status', isEqualTo: 'Confirmed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No confirmed requests available'));
        }

        final confirmedRequests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: confirmedRequests.length,
          itemBuilder: (context, index) {
            final request = confirmedRequests[index];
            final guideId = request['guideId'];

            if (guideId == null || guideId.isEmpty) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: const ListTile(
                  title: Text('No guide information available'),
                ),
              );
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Guide').doc(guideId).get(),
              builder: (context, guideSnapshot) {
                if (guideSnapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(title: Text('Loading guide information...')),
                  );
                }

                if (guideSnapshot.hasError || !guideSnapshot.hasData || !guideSnapshot.data!.exists) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: const ListTile(
                      title: Text('Guide information not found'),
                    ),
                  );
                }

                final guideData = guideSnapshot.data!;
                final guideName = guideData['name'] ?? 'No Name';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      guideName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(request['status'] ?? 'No status'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetailsPage(
                            aboutTrip: request['aboutTrip'] ?? 'No details',
                            expertise: request['expertise'] ?? 'No expertise',
                            places: request['places'] ?? 'No places',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTabContent(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class RequestDetailsPage extends StatelessWidget {
  final String aboutTrip;
  final String expertise;
  final String places;

  const RequestDetailsPage({
    Key? key,
    required this.aboutTrip,
    required this.expertise,
    required this.places,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Trip:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(aboutTrip),
            const SizedBox(height: 20),
            Text(
              'Expertise:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(expertise),
            const SizedBox(height: 20),
            Text(
              'Places:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(places),
          ],
        ),
      ),
    );
  }
}
