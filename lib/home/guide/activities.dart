import 'package:flutter/material.dart';

class Activity {
  final String tripName;
  final String destination;
  final String date;
  final String description;

  Activity({
    required this.tripName,
    required this.destination,
    required this.date,
    required this.description,
  });
}

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Dummy data for previous activities
  List<Activity> activities = [
    Activity(
      tripName: 'Beach Day',
      destination: 'Miami, FL',
      date: 'March 20, 2024',
      description: 'A fun day at the beach with water sports.',
    ),
    Activity(
      tripName: 'Mountain Hike',
      destination: 'Colorado Springs, CO',
      date: 'April 15, 2024',
      description: 'A challenging but rewarding mountain hike.',
    ),
    Activity(
      tripName: 'City Tour',
      destination: 'New York, NY',
      date: 'June 10, 2024',
      description: 'A guided tour through iconic New York landmarks.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];

          return GestureDetector(
            onTap: () {
              // Navigate to the details page for the selected activity
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityDetailPage(activity: activity),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(activity.tripName),
                subtitle: Text(
                  'Destination: ${activity.destination}\nDate: ${activity.date}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;

  const ActivityDetailPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.tripName,style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Destination: ${activity.destination}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${activity.date}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Description:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activity.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle any necessary action here, like viewing user feedback or booking details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Viewing details for this trip')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('View More Details',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}