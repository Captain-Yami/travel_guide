import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  // Filter options with selection states
  final Map<String, bool> budgetOptions = {
    '1000-1500': false,
    '1500-2000': false,
    '2000-2500': false,
    '2500-3000': false,
    '3000-3500': false,
    '3500-4000': false,
    '4000-4500': false,
    '5000': false,
  };

  final Map<String, bool> timeOptions = {
    '1 Hour': false,
    '1.30 Hour': false,
    '2 Hour': false,
    '2.30 Hour': false,
    '3 Hour': false,
    '3.30 Hour': false,
    '4 Hour': false,
    '12 hour': false,
  };

  final Map<String, bool> numberOfPlacesOptions = {
    '1-2 Places': false,
    '3-4 Places': false,
    '4': false,
    '5+ Places': false,
  };

  final Map<String, bool> preferredPlaceOptions = {
    'Temple': false,
    'Museum': false,
    'Beach': false,
    'Park': false,
    'Trekking': false,
  };

  // Variables to store the selected filters
  String selectedBudget = '';
  String selectedTime = '';
  String selectedNumberOfPlaces = '';
  String selectedPreferredPlace = '';

  // Function to show the popup dialog with checkbox options
  void _showFilterDialog(BuildContext context, String title, Map<String, bool> options, String filterType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      options[entry.key] = newValue!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Collect selected options into a list
                final selected = options.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                // Update the selected filter based on the type
                setState(() {
                  if (filterType == 'Budget') {
                    selectedBudget = selected.isNotEmpty ? selected.join(', ') : '';
                  } else if (filterType == 'Time') {
                    selectedTime = selected.isNotEmpty ? selected.join(', ') : '';
                  } else if (filterType == 'Number of Places') {
                    selectedNumberOfPlaces = selected.isNotEmpty ? selected.join(', ') : '';
                  } else if (filterType == 'Preferred Place') {
                    selectedPreferredPlace = selected.isNotEmpty ? selected.join(', ') : '';
                  }
                });

                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  // Function to query Firestore and match selected data
  Future<void> _checkMatchingData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Packages').get();

    List<QueryDocumentSnapshot> matchingPackages = [];

    for (var document in querySnapshot.docs) {
      var data = document.data() as Map<String, dynamic>;

      bool matches = true;

      // Ensure Firestore fields are not null before comparing
      if (selectedBudget.isNotEmpty &&
          data['budget'] != null &&
          !selectedBudget.contains(data['budget'])) {
        matches = false;
      }
      if (selectedTime.isNotEmpty &&
          data['time'] != null &&
          !selectedTime.contains(data['time'])) {
        matches = false;
      }
      if (selectedNumberOfPlaces.isNotEmpty &&
          data['number of places'] != null &&
          !selectedNumberOfPlaces.contains(data['number of places'])) {
        matches = false;
      }
      if (selectedPreferredPlace.isNotEmpty &&
          data['preferredPlace'] != null &&
          !selectedPreferredPlace.contains(data['preferredPlace'])) {
        matches = false;
      }

      if (matches) {
        matchingPackages.add(document);
      }
    }

    // Show the results of the query
    _showMatchingPackages(matchingPackages);
  }

  // Function to display the matching packages in sorted order
  void _showMatchingPackages(List<QueryDocumentSnapshot> packages) {
    // Sort the matching packages by budget (or any field you prefer)
    packages.sort((a, b) {
      var dataA = a.data() as Map<String, dynamic>;
      var dataB = b.data() as Map<String, dynamic>;

      // Ensure to safely handle the 'budget' field
      double budgetA = double.tryParse(dataA['budget'].toString()) ?? 0;
      double budgetB = double.tryParse(dataB['budget'].toString()) ?? 0;

      // Sorting by budget in ascending order
      return budgetA.compareTo(budgetB);
    });

    // Show the sorted packages
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Matching Packages'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: packages.isEmpty
                  ? const [Text('No matching packages found')]
                  : packages.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['details'] ?? 'No details'),
                        subtitle: Text(
                            'Budget: ${data['budget']} | Time: ${data['time']}'),
                      );
                    }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Your Trip'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button for Budget
              buildFilterButton('Budget', budgetOptions, 'Budget'),
              const SizedBox(height: 16),
              // Button for Time
              buildFilterButton('Time', timeOptions, 'Time'),
              const SizedBox(height: 16),
              // Button for Number of Places to Visit
              buildFilterButton('Number of Places to Visit', numberOfPlacesOptions, 'Number of Places'),
              const SizedBox(height: 16),
              // Button for Preferred Place
              buildFilterButton('Preferred Place', preferredPlaceOptions, 'Preferred Place'),
              const SizedBox(height: 24),
              // Apply button to check matching data
              ElevatedButton(
                onPressed: _checkMatchingData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 141, 143, 145),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Check Matching Packages',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build filter button
  Widget buildFilterButton(String title, Map<String, bool> options, String filterType) {
    String selectedText = options.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(', ');

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 141, 143, 145),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      ),
      onPressed: () => _showFilterDialog(context, title, options, filterType),
      child: Text(
        selectedText.isEmpty ? title : '$title: $selectedText',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
