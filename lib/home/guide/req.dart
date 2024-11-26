
import 'package:flutter/material.dart';

class req extends StatefulWidget {
  const req({super.key});

  @override
  State<req> createState() => _reqState();
}

class _reqState extends State<req> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two pages (tabs)
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to get current time in a formatted string
  String getCurrentTime() {
    final DateTime now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}'; // Format time as HH:mm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Requests',
                style: TextStyle(fontSize: 18), // Change font size here
              ),
            ),
            Tab(
              child: Text(
                'Bookings',
                style: TextStyle(fontSize: 18), // Change font size here
              ),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content of Page 1: Requests
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding for the content
              child: Column(
                children: [
                  // ElevatedButton 1 inside Container for Requests
                  Container(
                    width: double.infinity, // Full width of container
                    height: 100, // Set height for the button
                    margin:
                        const EdgeInsets.only(bottom: 16), // Space below button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality for this button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Distribute content across the button
                        children: [
                          // Profile Icon on the left side of the button
                          GestureDetector(
                            onTap: () {
                              // Implement image picker here for profile photo
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  AssetImage('asset/background3.jpg'),
                            ),
                          ),
                          const SizedBox(
                              width: 50), // Space between icon and text
                          const Text(
                            'Sairaj', // Replace with actual username
                            style: TextStyle(
                              fontSize: 18, // Font size for the username
color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 220),
                          // Time Text on the right side of the button
                          Text(
                            getCurrentTime(), // Display current time
                            style: TextStyle(
                              fontSize: 16, // Font size for the time
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ElevatedButton 2 inside Container for Requests
                  Container(
                    width: double.infinity, // Full width of container
                    height: 100, // Set height for the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality for this button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Distribute content across the button
                        children: [
                          // Profile Icon on the left side of the button
                          GestureDetector(
                            onTap: () {
                              // Implement image picker here for profile photo
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  AssetImage('asset/background3.jpg'),
                            ),
                          ),
                          const SizedBox(
                              width: 50), // Space between icon and text
                          const Text(
                            'Rhidu', // Replace with actual username
                            style: TextStyle(
                              fontSize: 18, // Font size for the username
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 220),
                          // Time Text on the right side of the button
                          Text(
                            getCurrentTime(), // Display current time
                            style: TextStyle(
                              fontSize: 16, // Font size for the time
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content of Page 2: Bookings
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding for the content
              child: Column(
                children: [
                  // ElevatedButton 1 inside Container for Bookings
                  Container(
                    width: double.infinity, // Full width of container
                    height: 100, // Set height for the button
margin:
                        const EdgeInsets.only(bottom: 16), // Space below button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality for this button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Distribute content across the button
                        children: [
                          // Profile Icon on the left side of the button
                          GestureDetector(
                            onTap: () {
                              // Implement image picker here for profile photo
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  AssetImage('asset/background3.jpg'),
                            ),
                          ),
                          const SizedBox(
                              width: 50), // Space between icon and text
                          const Text(
                            'Rhidu', // Replace with actual username
                            style: TextStyle(
                              fontSize: 18, // Font size for the username
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 220),
                          // Time Text on the right side of the button
                          Text(
                            getCurrentTime(), // Display current time
                            style: TextStyle(
                              fontSize: 16, // Font size for the time
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ElevatedButton 2 inside Container for Bookings
                  Container(
                    width: double.infinity, // Full width of container
                    height: 100, // Set height for the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality for this button
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Distribute content across the button
                        children: [
                          // Profile Icon on the left side of the button
                          GestureDetector(
                            onTap: () {
                              // Implement image picker here for profile photo
                            },
                            child: CircleAvatar(
radius: 35,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage:
                                  AssetImage('asset/background3.jpg'),
                            ),
                          ),
                          const SizedBox(
                              width: 50), // Space between icon and text
                          const Text(
                            'Sairaj', // Replace with actual username
                            style: TextStyle(
                              fontSize: 18, // Font size for the username
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 220),
                          // Time Text on the right side of the button
                          Text(
                            getCurrentTime(), // Display current time
                            style: TextStyle(
                              fontSize: 16, // Font size for the time
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}