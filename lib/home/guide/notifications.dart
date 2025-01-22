import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final String guideId = FirebaseAuth.instance.currentUser!.uid;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(255, 253, 253, 253),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      ),
      body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('Notifications')
      .where('guideId', isEqualTo: guideId)
      .orderBy('time', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      print("Error: ${snapshot.error}");
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      print("No notifications found");
      return const Center(child: Text('No notifications yet.'));
    }

    final notifications = snapshot.data!.docs;
    print("Fetched ${notifications.length} notifications");

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notificationData =
            notifications[index].data() as Map<String, dynamic>;
        return _buildNotificationItem(
          icon: notificationData['type'],
          text: notificationData['text'],
          time: _formatTime(notificationData['time']),
        );
      },
    );
  },
),
    );
  }

  Widget _buildNotificationItem({
    required String icon,
    required String text,
    required String time,
  }) {
    IconData notificationIcon;
    switch (icon) {
      case "message":
        notificationIcon = Icons.message;
        break;
      case "request":
        notificationIcon = Icons.book;
        break;
      default:
        notificationIcon = Icons.notifications;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 25,
            child: Icon(
              notificationIcon,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}