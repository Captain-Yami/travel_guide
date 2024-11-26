import 'package:flutter/material.dart';
import 'package:travel_guide/home/admin/admin_hotels.dart';
import 'package:travel_guide/home/admin/admin_places.dart';
import 'package:travel_guide/home/admin/admin_ratings.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  // Navigation functions
  void navigateToPlaces() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPlaces()),
    );
  }

  void navigateToHotels() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminHotels()),
    );
  }

  void navigateToRatings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminRatings()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(
            'Admin Homepage',
            style: TextStyle(
              color: Colors.black, // Text color
              fontSize: 16,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Stack all widgets vertically
          children: [
            // "Analysis" container aligned to the center
            Align(
              alignment: Alignment.center, // Aligns the container to the center
              child: Container(
                width: 350, // Custom width for "Analysis" container
                height: 150, // Adjust height to fit all text widgets
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 5, // Blur radius
                      offset: Offset(
                          0, 3), // Shadow position (horizontal, vertical)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align items at the top
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center items horizontally
                  children: [
                    Text(
                      'Analysis', // Text for Analysis
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 16, // Larger font size for Analysis
                      ),
                    ),
                    SizedBox(
                        height:
                            20), // Space between Analysis and the next texts
                    // Row for placing Success, Failed, and Pending on the left side
                    Align(
                      alignment:
                          Alignment.centerLeft, // Align the texts to the left
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align texts to the left
                        children: [
                          Text(
                            'Success', // Text for Success
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 14, // Smaller font size for other texts
                            ),
                          ),
                          SizedBox(
                              height: 10), // Space between Success and Failed
                          Text(
                            'Failed', // Text for Failed
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 14, // Smaller font size for other texts
                            ),
                          ),
                          SizedBox(
                              height: 10), // Space between Failed and Pending
                          Text(
                            'Pending', // Text for Pending
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 14, // Smaller font size for other texts
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height:
                    20), // Space between the Analysis container and the next containers

            // Row to hold "User" and "Guide" containers side by side
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centers the children in the Row
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 5, // Blur radius
                        offset: Offset(
                            0, 3), // Shadow position (horizontal, vertical)
                      ),
                    ],
                  ),
                  child: Text(
                    'User',
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
                SizedBox(width: 10), // Space between the containers
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Shadow color
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 5, // Blur radius
                        offset: Offset(
                            0, 3), // Shadow position (horizontal, vertical)
                      ),
                    ],
                  ),
                  child: Text(
                    'Guide',
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
              ],
            ),
            Spacer(), // This will push the buttons to the bottom of the screen

            // Row for placing the buttons horizontally
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centers buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: navigateToPlaces,
                  child: Text('Places'),
                ),
                SizedBox(width: 10), // Space between buttons
                ElevatedButton(
                  onPressed: navigateToHotels,
                  child: Text('Hotels'),
                ),
                SizedBox(width: 10), // Space between buttons
                ElevatedButton(
                  onPressed: navigateToRatings,
                  child: Text('Ratings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
