import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_guide/home/guide/userchat.dart'; // Ensure this import points to your ChatScreen file
import 'package:intl/intl.dart'; // For formatting the time

class ChatsPageguide extends StatefulWidget {
  const ChatsPageguide({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPageguide> {
  final String _currentUserId =
      FirebaseAuth.instance.currentUser!.uid; // The users's user ID

  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true; // Added loading state

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
          .where('userId', isEqualTo: _currentUserId)
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
            .doc(data[
                'guideId']) // Get the guide's data using the guide's userId
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
          lastMessage = messageData['message'] ?? 'No message';
          messageTime = messageData['timestamp'] != null
              ? DateFormat('hh:mm a')
                  .format(messageData['timestamp'].toDate().toLocal())
              : 'No timestamp';
        }

        fetchedChats.add({
          'chatId': chatId,
          'guideId': data['guideId'] ?? 'Guide',
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
        isLoading = false; // Set loading to false after fetching
      });
    } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        isLoading = false; // Ensure loading stops even on error
      });
    }
  }

  // Filter chats based on search query
  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats
          .where((chat) => chat['guideName'].toLowerCase().contains(query))
          .toList();
    });
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
      appBar: AppBar(
        title: Text(
          'Chats',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black, // Customize the loading color
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 5),
                // Search Bar
                Container(
                  width: 450, // Set the width of the TextFormField
                  height: 60, // Set the height of the TextFormField
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by guide name', // Optional hint text
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
                          vertical: 15,
                          horizontal:
                              20), // Padding to adjust the internal space
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
                                  backgroundImage: chat['guideProfilePicture']
                                          .toString()
                                          .startsWith('http')
                                      ? NetworkImage(
                                          chat['guideProfilePicture'])
                                      : AssetImage(chat['guideProfilePicture'])
                                          as ImageProvider,
                                ),
                                title: Text(
                                  chat['guideName'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        chat['lastMessage'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 40, 40, 40),
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
                                onTap: () {
                                  // Navigate to the ChatScreen when a user is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        chatId: chat['chatId'],
                                        userId: _currentUserId,
                                        userName: chat['userName'],
                                        guideName: chat['guideName'],
                                        guideId: chat[
                                            'guideId'], // Send guideId here
                                        userProfilePic: chat['profilePicture'],
                                        guideProfilePic:
                                            chat['guideProfilePicture'],
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
