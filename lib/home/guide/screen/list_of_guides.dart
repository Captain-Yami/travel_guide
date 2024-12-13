/*import 'package:flutter/material.dart';
import 'package:travel_guide/home/guide/screen/guide_profile.dart';

// Assume you have a GuideProfilePage to navigate to

class ListOfGuides extends StatefulWidget {
  const ListOfGuides({super.key});

  @override
  State<ListOfGuides> createState() => _ListOfGuidesState();
}

class _ListOfGuidesState extends State<ListOfGuides> {
  // List of guide names
  final List<String> guides = ['Guide 1', 'Guide 2', 'Guide 3', 'Guide 4'];

  // Function to navigate to GuideProfilePage when a card is tapped
  void _navigateToGuideProfile(String guideName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Guidedetails(guidename: guideName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Guides',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: guides.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                guides[index],
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Navigate to GuideProfilePage when a card is tapped
                _navigateToGuideProfile(guides[index]);
              },
            ),
          );
        },
      ),
    );
  }
}*/