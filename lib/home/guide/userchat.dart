import 'package:flutter/material.dart';

class UserChat extends StatefulWidget {
  final String name;
  final String profilePic;
  final String lastMessage;
  final String messageTime;

  const UserChat({
    super.key,
    required this.name,
    required this.profilePic,
    required this.lastMessage,
    required this.messageTime,
  });

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'Guide',
      'message': 'Hello! How can I assist you today?',
    },
    {
      'sender': 'User',
      'message': 'Hi! I need help with my account.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 41, 41), // Set AppBar background to black
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.profilePic), // Use profilePic passed from RequestDetailsPage
            ),
            const SizedBox(width: 15),
            Text(widget.name, style: const TextStyle(color: Colors.white)), // Display name passed from RequestDetailsPage
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white), // White icon
              onPressed: () {
                // Handle settings click here
              },
            ),
          ],
        ),
        foregroundColor: Colors.white, // Ensures text and icons are white
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              reverse: true, // Display messages from bottom to top
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'User';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Message Input Area
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.insert(
                          0,
                          {'sender': 'User', 'message': _messageController.text},
                        );
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}