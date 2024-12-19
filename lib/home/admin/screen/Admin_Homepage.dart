import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firebase import
import 'package:fl_chart/fl_chart.dart'; // Import for PieChart
import 'package:travel_guide/home/admin/places/hotels.dart';
import 'package:travel_guide/home/admin/screen/add_places.dart';
import 'package:travel_guide/home/admin/screen/admin_guides.dart';
import 'package:travel_guide/home/admin/screen/admin_ratings.dart';
import 'package:travel_guide/home/admin/screen/admin_complaints.dart';
import 'package:travel_guide/home/admin/screen/admin_users.dart'; // Make sure to import Complaints page

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  // Store the touched index
  int touchedIndex = -1;

  // Navigation functions
  void navigateToUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminUsers()),
    );
  }

  void navigateToGuides() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminGuides()),
    );
  }

  void navigateToRatings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminComplaints()),
    );
  }

  void navigateToComplaints() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminComplaints()), // Navigate to AdminComplaints page
    );
  }

  void navigateToHotels() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Hotels()), // Navigate to AdminComplaints page
    );
  }

  // Sample data for ratings
  final List<PieChartSectionData> pieSections = [
    PieChartSectionData(
      value: 50, // Percentage for 'Best' rating
      color: Colors.green, // Color for 'Best'
      title: 'Best',
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 30, // Percentage for 'Good' rating
      color: Colors.blue, // Color for 'Good'
      title: 'Good',
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 20, // Percentage for 'Worst' rating
      color: Colors.red, // Color for 'Worst'
      title: 'Worst',
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ];

  // Fetch the total number of users from the "Users" collection
  Future<int> fetchUserCount() async {
    var snapshot = await FirebaseFirestore.instance.collection('Users').get();
    return snapshot.size; // Return the number of documents in the collection
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    20), // Space between the Analysis container and the pie chart
            // Pie Chart Widget for User Ratings with Animation
            Container(
              width: double.infinity,
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  centerSpaceRadius: 30,
                  sectionsSpace: 0,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                      // Check for the tap event and ensure we only respond to tap
                      if (event is FlTapUpEvent) {
                        setState(() {
                          if (pieTouchResponse != null &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            // Navigate based on touched section
                            if (touchedIndex == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                       AdminRatings()), // Redirect to AdminPlaces as an example
                              );
                            } else if (touchedIndex == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         AdminRatings()), // Redirect to AdminHotels as an example
                              );
                            } else if (touchedIndex == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRatings()), // Redirect to AdminRatings as an example
                              );
                            }
                          }
                        });
                      }
                    },
                  ),
                  startDegreeOffset: 90, // Offset the start angle for animation
                ),
              ),
            ),
            SizedBox(
                height:
                    20), // Space between the Pie chart and the next containers
            // Column to hold buttons in two rows
            Column(
              children: [
                // First row of buttons
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers the children in the Row
                  children: [
                    // User button with dynamic count from Firestore
                    FutureBuilder<int>(
                      future: fetchUserCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Loading indicator
                        }
                        if (snapshot.hasError) {
                          return const Text('Error fetching user count');
                        }
                        int userCount = snapshot.data ?? 0;

                        return ElevatedButton(
                          onPressed: navigateToUsers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 220, 222, 224), // Button color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            shadowColor: Colors.black.withOpacity(0.3),
                            elevation: 5,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Users',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 3, 3, 3),
                                    fontSize: 14),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '($userCount)', // Display user count
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 3, 3, 3),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10), // Space between the buttons
                    ElevatedButton(
                      onPressed: navigateToGuides,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 228, 233, 228), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      child: Text(
                        'Guide',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 9, 9, 9),
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                // Second row of buttons
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers the children in the Row
                  children: [
                    ElevatedButton(
                      onPressed: navigateToComplaints,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 234, 230, 230), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      child: Text(
                        'Complaints',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 10), // Space between the buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPlacesPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      child: Text(
                        'Add Places',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10),
                     ElevatedButton(
                      onPressed: navigateToHotels,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 234, 230, 230), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 5,
                      ),
                      
                      child: Text(
                        'Hotels',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            Spacer(), // This will push the content above to the top of the screen
          ],
        ),
      ),
    );
  }
}
