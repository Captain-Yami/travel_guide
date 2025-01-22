import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId; // Unique chat ID for user-guide pair
  final String guideId; // Guide's ID
  final String userId; // User's ID
  final String userName; // User's name (optional)
  final String guideName; // Guide's name (optional)
  final String userProfilePic; // User's profile picture URL
  final String guideProfilePic; // Guide's profile picture URL

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.guideId,
    required this.userId,
    required this.userName,          
    required this.guideName,
    required this.userProfilePic,
    required this.guideProfilePic,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Send message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final senderId = FirebaseAuth.instance.currentUser!.uid;

    final confirmedRequestDetails = {
      'guideId': widget.guideId,
      'userId': widget.userId,
      'userName': widget.userName,
      'guideName': widget.guideName,
    };

    await FirebaseFirestore.instance.collection('Chats').doc(widget.chatId).set(confirmedRequestDetails);
                                                        
    await FirebaseFirestore.instance                   
        .collection('Chats')                           
        .doc(widget.chatId)                            
        .collection('messages')                        
        .add({                                         
      'senderId': senderId,                             
      'message': message,                              
      'timestamp': Timestamp.now(),                    
    });                                                
                                                       
    _messageController.clear();                        
  }  

   // Clear all messages in the chat
  Future<void> _clearChat() async {
    try {
      final messageSnapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatId)
          .collection('messages')
          .get();

      for (var messageDoc in messageSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to clear chat')),
      );
    }
  }                                                  
                                                       
  // Determine whether to show the user's name or guide's name in the app bar
  String get appBarTitle {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == widget.guideId) {
      return widget.userName; // If the current user is the guide, show user's name
    } else {
      return widget.guideName; // If the current user is the user, show guide's name
    }
  }

  String get appBarProfilePic {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId == widget.guideId) {
      return widget.userProfilePic; // Show user's profile pic if current user is the guide
    } else {
      return widget.guideProfilePic; // Show guide's profile pic if current user is the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(appBarProfilePic), // Profile pic on the left of the title
            ),
            const SizedBox(width: 10),
            Text(appBarTitle),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 6.0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_chat') {
                // Confirm before clearing chat
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Chat'),
                    content: const Text(
                        'Are you sure you want to clear all messages in this chat?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _clearChat();
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.settings),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_chat',
                child: Text('Clear Chat'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final isSentByMe =
                        messageData['senderId'] == FirebaseAuth.instance.currentUser!.uid;

                    return Align(
                      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust width to 70% of screen width
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSentByMe
                                ? const Color.fromARGB(255, 240, 240, 240)
                                : const Color.fromARGB(255, 109, 108, 108),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  messageData['message'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSentByMe ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),         
                  color: Colors.black,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}