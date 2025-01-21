import 'package:flutter/material.dart';
import 'package:travel_guide/home/admin/places/beaches.dart';
import 'package:travel_guide/home/admin/places/forts_museum.dart';
import 'package:travel_guide/home/admin/places/temples.dart';
import 'package:travel_guide/home/admin/places/trekking.dart';

class AddPlacesPage extends StatelessWidget {
  const AddPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 26, 26),
        title: Text(
          'Add Places',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Container(
        // Adding a linear gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(12, 22, 21, 1), // Dark black
              Color.fromARGB(255, 16, 31, 29), // Slightly lighter black
              Color.fromARGB(255, 14, 26, 25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beach Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            adminBeaches(locationType: 'Beaches')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 50), // Increased size
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.green, // Green card background
                    borderRadius:
                        BorderRadius.circular(12), // Slightly rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 3),
                        blurRadius: 8, // Increased blur for the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Beaches',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Temples Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            adminTemples(locationType: 'Temples')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 50), // Increased size
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.green, // Green card background
                    borderRadius:
                        BorderRadius.circular(12), // Slightly rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 3),
                        blurRadius: 8, // Increased blur for the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Temples',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Trekking Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            adminTrekking(locationType: 'Trekking')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 50), // Increased size
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.green, // Green card background
                    borderRadius:
                        BorderRadius.circular(12), // Slightly rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 3),
                        blurRadius: 8, // Increased blur for the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Trekking',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Forts Museum Button (Newly added)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            adminFortsMuseum(locationType: 'FortsMuseum')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 50), // Increased size
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.green, // Green card background
                    borderRadius:
                        BorderRadius.circular(12), // Slightly rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 3),
                        blurRadius: 8, // Increased blur for the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Forts Museum',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
