import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

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
          .where('user', isEqualTo: currentUserId)
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
              future: FirebaseFirestore.instance
                  .collection('Guide')
                  .doc(guideId)
                  .get(),
              builder: (context, guideSnapshot) {
                if (guideSnapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    margin: EdgeInsets.all(8.0),
                    child:
                        ListTile(title: Text('Loading guide information...')),
                  );
                }

                if (guideSnapshot.hasError ||
                    !guideSnapshot.hasData ||
                    !guideSnapshot.data!.exists) {
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                            guideId: guideId,
                            userId: FirebaseAuth.instance.currentUser!.uid,
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
  final String guideId; // ID of the guide
  final String userId; // ID of the user submitting feedback

  const RequestDetailsPage({
    Key? key,
    required this.aboutTrip,
    required this.expertise,
    required this.places,
    required this.guideId,
    required this.userId,
  }) : super(key: key);

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    double selectedRating = 0; // Variable to store the selected star rating

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Send Feedback'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rate the Guide:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          selectedRating > index
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1.0; // Update rating
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write your feedback here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final feedbackText = feedbackController.text;

                    if (feedbackText.isNotEmpty && selectedRating > 0) {
                      try {
                        // Save feedback to Firestore
                        await FirebaseFirestore.instance
                            .collection('Guide')
                            .doc(guideId)
                            .collection('feedback')
                            .add({
                          'feedback': feedbackText, // Textual feedback
                          'rating': selectedRating, // Star rating
                          'userId': userId, // ID of the user
                          'timestamp': Timestamp.now(), // Submission time
                        });
                        // Mark trip as complete
                        await FirebaseFirestore.instance
                            .collection('completedTrips')
                            .add({
                          'status': 'complete', // Mark as complete
                          'timestamp': Timestamp.now(), // Completion time
                        });

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Feedback sent successfully!')),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to send feedback.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please provide both rating and feedback.')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trip Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.blue),
                title: const Text(
                  'About Trip:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  aboutTrip,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.explore, color: Colors.orange),
                title: const Text(
                  'Expertise:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  expertise,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.place, color: Colors.green),
                title: const Text(
                  'Places:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  places,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // Store status as Drop in the completedTrips collection
                          await FirebaseFirestore.instance
                              .collection('completedTrips')
                              .add({
                            'status': 'Drop', // Set status as Drop
                            'timestamp': Timestamp.now(), // Current timestamp
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Trip marked as dropped!')),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to drop the trip.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Set the button color to red
                      ),
                      child: const Text('Drop'),
                    ),
                    const SizedBox(width: 20), // Space between the buttons
                    ElevatedButton(
                      onPressed: () => _showFeedbackDialog(context),
                      child: const Text('Complete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
