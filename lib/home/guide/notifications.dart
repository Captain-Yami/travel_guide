import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, String>> recentNotifications = [
    {
      "icon": "message",
      "text": "John Doe sent you a message",
      "time": "2m ago",
    },
    {
      "icon": "star",
      "text": "You received a 5-star review!",
      "time": "10m ago",
    },
    {
      "icon": "book",
      "text": "New booking request from Sarah",
      "time": "20m ago",
    },
  ];

  final List<Map<String, String>> earlierNotifications = [
    {
      "icon": "calendar",
      "text": "Your availability has been updated",
      "time": "Yesterday",
    },
    {
      "icon": "person",
      "text": "Tom started following you",
      "time": "2 days ago",
    },
    {
      "icon": "review",
      "text": "Anna left a review for your last trip",
      "time": "3 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color.fromARGB(255, 253, 253, 253),),
        ),
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          const Text(
            "Recent",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...recentNotifications.map((notification) {
            return _buildNotificationItem(
              icon: notification["icon"]!,
              text: notification["text"]!,
              time: notification["time"]!,
            );
          }).toList(),
          const SizedBox(height: 20),
          const Text(
            "Earlier",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...earlierNotifications.map((notification) {
            return _buildNotificationItem(
              icon: notification["icon"]!,
              text: notification["text"]!,
              time: notification["time"]!,
            );
          }).toList(),
        ],
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
      case "star":
        notificationIcon = Icons.star;
        break;
      case "book":
        notificationIcon = Icons.book;
        break;
      case "calendar":
        notificationIcon = Icons.calendar_today;
        break;
      case "person":
        notificationIcon = Icons.person;
        break;
      case "review":
        notificationIcon = Icons.rate_review;
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
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add actions for notification items, like delete or view details
            },
          ),
        ],
      ),
    );
  }
}