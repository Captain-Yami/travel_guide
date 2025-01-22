import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_guide/home/guide/userchat.dart'; // Ensure this import points to your ChatScreen file
import 'package:intl/intl.dart'; // For formatting the time

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final String _currentUserId =
      FirebaseAuth.instance.currentUser!.uid; // The guide's user ID

  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
  String? _longPressedChatId; // Variable to store the long-pressed chatId

  @override
  void initState() {
    super.initState();
    _fetchChats();
    _searchController.addListener(_filterChats);
  }

  // Fetch the chats of the guide from Firestore
  Future<void> _fetchChats() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .where('guideId', isEqualTo: _currentUserId)
          .get();

      List<Map<String, dynamic>> fetchedChats = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final chatId = doc.id;

        // Fetch the user's profile picture
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(data['userId'])
            .get();

        String profilePicture = userDoc.data()?['profile_picture'] ??
            'asset/background3.jpg'; // Fallback to default avatar if not available

        // Fetch the guide's profile picture from the Guide collection
        final guideDoc = await FirebaseFirestore.instance
            .collection('Guide')
            .doc(_currentUserId) // Get the guide's data using the guide's userId
            .get();

        String guideProfilePicture = guideDoc.data()?['profile_picture'] ??
            'asset/background3.jpg'; // Fallback to default avatar if not available

        // Fetch the last message from the messages subcollection
        final messageSnapshot = await FirebaseFirestore.instance
            .collection('Chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        String lastMessage = 'No message';
        String messageTime = 'No timestamp';

        if (messageSnapshot.docs.isNotEmpty) {
          final messageData = messageSnapshot.docs.first.data();
          lastMessage = messageData['message'] ?? '';
          messageTime = messageData['timestamp'] != null
              ? DateFormat('hh:mm a')
                  .format(messageData['timestamp'].toDate().toLocal())
              : '';
        }

        fetchedChats.add({
          'chatId': chatId,
          'userId': data['userId'] ?? 'Unknown User',
          'userName': data['userName'] ?? 'Unknown User',
          'guideName': data['guideName'] ?? 'Guide',
          'lastMessage': lastMessage,
          'messageTime': messageTime,
          'profilePicture': profilePicture,
          'guideProfilePicture': guideProfilePicture,
        });
      }

      setState(() {
        _chats = fetchedChats;
        _filteredChats = _chats; // Initialize filtered chats
      });
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  // Filter chats based on search query
  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats
          .where((chat) => chat['userName'].toLowerCase().contains(query))
          .toList();
    });
  }

  // Delete chat from Firestore
  Future<void> _deleteChat(String chatId) async {
    try {
      // Delete the chat document from the 'Chats' collection
      await FirebaseFirestore.instance.collection('Chats').doc(chatId).delete();

      // Delete the associated messages subcollection
      final messageSnapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var messageDoc in messageSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      setState(() {
        _chats.removeWhere((chat) => chat['chatId'] == chatId);
        _filteredChats = _chats; // Update filtered chats
        _longPressedChatId = null; // Reset long-pressed state
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat deleted successfully')),
      );
    } catch (e) {
      print('Error deleting chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete chat')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterChats);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 5),
          // Search Bar
          Container(
            width: 450, // Set the width of the TextFormField
            height: 60, // Set the height of the TextFormField
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by user name', // Optional hint text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Oval shape
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 5, 0, 0),
                    width: 2, // Border color and thickness
                  ),
                ),
                suffixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 1, 2, 3)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20), // Padding to adjust the internal space
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 5),
          // Chat List
          Expanded(
            child: _filteredChats.isEmpty
                ? const Center(
                    child: Text(
                      'No chats found.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = _filteredChats[index];
                      bool isLongPressed = _longPressedChatId == chat['chatId'];
                      return Card(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: chat['profilePicture']
                                    .toString()
                                    .startsWith('http')
                                ? NetworkImage(chat['profilePicture'])
                                : AssetImage(chat['profilePicture'])
                                    as ImageProvider,
                          ),
                          title: Text(
                            chat['userName'],
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  chat['lastMessage'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 40, 40, 40),
                                  ),
                                ),
                              ),
                              Text(
                                chat['messageTime'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: isLongPressed
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Show confirmation dialog before deleting
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Chat'),
                                        content: const Text(
                                            'Are you sure you want to delete this chat?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteChat(chat['chatId']);
                                              Navigator.pop(context); // Close dialog
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : null,
                          onLongPress: () {
                            setState(() {
                              _longPressedChatId = _longPressedChatId == chat['chatId'] ? null : chat['chatId'];
                            });
                          },
                          onTap: () {
                            // Navigate to the ChatScreen when a user is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chat['chatId'],
                                  userId: chat['userId'],
                                  userName: chat['userName'],
                                  guideName: chat['guideName'],
                                  guideId: _currentUserId, // Send guideId here
                                  userProfilePic: chat['profilePicture'],
                                  guideProfilePic: chat['guideProfilePicture'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}