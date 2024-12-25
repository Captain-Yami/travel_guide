import 'package:flutter/material.dart';
import 'package:travel_guide/api.dart';
import 'package:travel_guide/data.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  // Filter options with selection states
  final Map<String, bool> budgetOptions = {
    '1000-1500': false,
    '1500-2000': false,
    '2000-2500': false,
    '2500-3000': false,
    '3000-3500': false,
    '3500-4000': false,
    '4000-4500': false,
    '4500-5000': false,
  };

  final Map<String, bool> timeOptions = {
    '1 Hour': false,
    '1.30 Hour': false,
    '2 Hour': false,
    '2.30 Hour': false,
    '3 Hour': false,
    '3.30 Hour': false,
    '4 Hour': false,
  };

  final Map<String, bool> placeOptions = {
    'Temple': false,
    'Museum': false,
    'Beach': false,
    'Park': false,
    'Trekking': false,
  };

  final Map<String, bool> kmOptions = {
    '0-5 Km': false,
    '5-10 Km': false,
    '10-15 Km': false,
    '15-20 Km': false,
    '20-25 Km': false,
  };

  // Function to show the popup dialog with checkbox options
  void _showFilterDialog(BuildContext context, String title, Map<String, bool> options) {
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
        title: const Text('Start Your Journey'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        children: [
          // Filters section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Filter button for Budget
                buildFilterButton('Budget', budgetOptions),
                const SizedBox(height: 10),
                // Filter button for Time
                buildFilterButton('Time', timeOptions),
                const SizedBox(height: 10),
                // Filter button for Place
                buildFilterButton('Place', placeOptions),
                const SizedBox(height: 10),
                // Filter button for Distance
                buildFilterButton('Distance', kmOptions),
              ],
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () async {
                // Handle apply action
               /* final selectedFilters = {
                  'Budget': budgetOptions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
                  'Time': timeOptions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
                  'Place': placeOptions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
                  'Distance': kmOptions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList(),
                };*/



               /* showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Selected Filters'),
                    content: Text(selectedFilters.entries
                        .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
                        .join('\n')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );*/
                List scheduledDatalist= [];
                var aidata = await getRecommendedPlaces(currentLocation:[11.97040711534504, 75.66143691162308],

                budget: 100,
                availableTime: 2,
                maxDistance: 50,
                type: 'Beach');
                
               scheduledDatalist = aidata['recommended_places'].map((e){
                String place= e['Place Name'];
                var data =kannurTripPlan.firstWhere((element) {
                  return element["place name"]==place;
                },);
                return data;
               }).toList();

                print(scheduledDatalist);
                var data =kannurTripPlan.firstWhere((element) {
                  return element["place name"]=="payyambalam Beach";
                },);
                
                var schedule= data["Trip plan"].firstWhere((element){
                  return element['time']=="6:00 AM";
                });
                
              },
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build filter buttons to open the popup dialog
  Widget buildFilterButton(String title, Map<String, bool> options) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: () => _showFilterDialog(context, title, options),
      child: Text(
        '$title Filters',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
