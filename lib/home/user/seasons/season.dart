import 'package:flutter/material.dart';

class Season extends StatefulWidget {
  const Season({super.key});

  @override
  State<Season> createState() => _SeasonState();
}

class _SeasonState extends State<Season> {
  // Placeholder navigation or functionality for each button
  void _navigateToMonsoon() {
    // Placeholder for Monsoon button action
    print("Navigating to Monsoon details");
  }

  void _navigateToTheyyam() {
    // Placeholder for Theyyam button action
    print("Navigating to Theyyam details");
  }

  void _navigateToWinter() {
    // Placeholder for Winter button action
    print("Navigating to Winter details");
  }

  void _navigateToSummer() {
    // Placeholder for Summer button action
    print("Navigating to Summer details");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        title: Row(
          children: [
             const SizedBox(width: 140),
        const Text('Seasons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 253, 253, 253),
              ),),
          ],     
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 10, // Space between columns
          mainAxisSpacing: 20, // Space between rows
          childAspectRatio: 2, // Adjust the aspect ratio to control the button size
          children: [
            // Button 1: Monsoon
            ElevatedButton(
              onPressed: _navigateToMonsoon,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: const Text(
                'Monsoon',
                style: TextStyle(fontSize: 16, color: Colors.black), // Medium font size
              ),
            ),

            // Button 2: Theyyam
            ElevatedButton(
              onPressed: _navigateToTheyyam,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: const Text(
                'Theyyam',
                style: TextStyle(fontSize: 16, color: Colors.black), // Medium font size
              ),
            ),

            // Button 3: Winter
            ElevatedButton(
              onPressed: _navigateToWinter,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: const Text(
                'Winter',
                style: TextStyle(fontSize: 16, color: Colors.black), // Medium font size
              ),
            ),

            // Button 4: Summer
            ElevatedButton(
              onPressed: _navigateToSummer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12), // Medium size button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: const Text(
                'Summer',
                style: TextStyle(fontSize: 16, color: Colors.black), // Medium font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
