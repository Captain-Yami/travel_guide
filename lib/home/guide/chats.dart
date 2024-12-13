import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/userchat.dart'; // Ensure this import is correct

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

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController _searchController = TextEditingController();
  List<UserChatModel> _chats = [
    UserChatModel(
      name: 'John Doe',
      profilePic: 'asset/background3.jpg',
      lastMessage: 'Hey, are you available?',
      messageTime: '10:15 AM',
    ),
    UserChatModel(
      name: 'Jane Smith',
      profilePic: 'asset/background3.jpg',
      lastMessage: 'Let\'s catch up soon!',
      messageTime: 'Yesterday',
    ),
    UserChatModel(
      name: 'Alice Brown',
      profilePic: 'asset/background3.jpg',
      lastMessage: 'Got the details, thanks!',
      messageTime: '3:45 PM',
    ),
  ];

  List<UserChatModel> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = _chats;
    _searchController.addListener(_filterChats);
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats
          .where((chat) => chat.name.toLowerCase().contains(query))
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
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: <Widget>[
            // Search Bar
            Container(
              width: 400,
              height: 60,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 5, 0, 0),
                      width: 2,
                    ),
                  ),
                  suffixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 1, 2, 3)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),

            // Chat List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredChats.length,
                itemBuilder: (context, index) {
                  final userChat = _filteredChats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(userChat.profilePic),
                    ),
                    title: Text(userChat.name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userChat.lastMessage, style: const TextStyle(fontSize: 14)),
                        Text(userChat.messageTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    onTap: () {
                      // Navigate to UserChat screen with the user data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserChat(
                            name: userChat.name,
                            profilePic: userChat.profilePic,
                            lastMessage: userChat.lastMessage,
                            messageTime: userChat.messageTime,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}