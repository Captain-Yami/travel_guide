import 'package:flutter/material.dart';
import 'package:travel_guide/api.dart';
import 'package:travel_guide/data.dart';
import 'package:travel_guide/distance_calculator.dart';
import 'package:travel_guide/timecomparison.dart';

class Start extends StatefulWidget {
  const Start({super.key, required Map<String, double> userLocation});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  // Filter options with selection states
  final List<String> budgetOptions = [
  '1000-1500',
  '1500-2000',
  '2000-2500',
  '2500-3000',
  '3000-3500',
  '3500-4000',
  '4000-4500',
  '4500-5000',
];

final List<String> timeOptions = [
  '1 Hour',
  '1.30 Hour',
  '2 Hour',
  '2.30 Hour',
  '3 Hour',
  '3.30 Hour',
  '4 Hour',
];

final List<String> placeOptions = [
  'Temple',
  'Museum',
  'Beach',
  'Park',
  'Trekking',
];

final List<String> kmOptions = [
  '0-5 Km',
  '5-10 Km',
  '10-15 Km',
  '15-20 Km',
  '20-25 Km',
];

  // Function to show the popup dialog with checkbox options
  void _showFilterDialog(
      BuildContext context, String title, Map<String, bool> options) {
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

  List<Widget> buildFilterChips(List<String> options, Set<String> selectedOptions) {
  return options.map((option) {
    return FilterChip(
      label: Text(option),
      selected: selectedOptions.contains(option),
      onSelected: (isSelected) {
        setState(() {
          if (isSelected) {
            selectedOptions.add(option);
          } else {
            selectedOptions.remove(option);
          }
        });
      },
    );
  }).toList();
}

 final Set<String> selectedBudgetOptions = {};
  final Set<String> selectedTimeOptions = {};
  final Set<String> selectedPlaceOptions = {};
  final Set<String> selectedKmOptions = {};

  List<Map<String, String>> scheduledTrips = [];
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
                // Budget Filter
                buildFilterSection('Budget', budgetOptions, selectedBudgetOptions),
                const SizedBox(height: 10),
                // Time Filter
                buildFilterSection('Time', timeOptions, selectedTimeOptions),
                const SizedBox(height: 10),
                // Place Filter
                buildFilterSection('Place', placeOptions, selectedPlaceOptions),
                const SizedBox(height: 10),
                // Distance Filter
                buildFilterSection('Distance', kmOptions, selectedKmOptions),
              ],
            ),
          ),
         Expanded(
            child: ListView.builder(
              itemCount: scheduledTrips.length,
              itemBuilder: (context, index) {
                final schedule = scheduledTrips[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                   onPressed: null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule['place name'] ?? 'No Place',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Time: ${schedule['time'] ?? 'No Time'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'activity: ${schedule['activity'] ?? 'No activity'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 151, 152, 153),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () async {

                try {
                  // Fetch AI-recommended places
                  var aidata = await getRecommendedPlaces(
                    currentLocation: [11.97040711534504, 75.66143691162308],
                    budget: 100,
                    availableTime: 2,
                    maxDistance: 100,
                    type: 'Beach',
                  );

                  List<dynamic> recommendedPlaces =
                      aidata['recommended_places'];
                  List<dynamic> selectedPlaces = [];

                  // Fetch up to 4 places
                  for (int i = 0; i < recommendedPlaces.length && i < 4; i++) {
                    selectedPlaces.add(recommendedPlaces[i]);
                  }

                  print(selectedPlaces);

                  var startlatitudefirst = 11.97040711534504;
                  var startlongitudefirst = 75.66143691162308;
                  var startTime = '7:00 AM';

                  // Process the recommended places
                  for (var e in selectedPlaces) {
                    var distance = calculateDistance(
                        startlatitudefirst,
                        startlongitudefirst,
                        e['Location']['Latitude'],
                        e['Location']['Longitude']);

                    var userinputtime = getTimeFromDist(distance, startTime);

                    String place = e['Place Name'];

                    // Find and add matching places from kannurTripPlan
                    Map<String, String>?
                        schedule; // Adjusted type to match expectations
                    for (var element in kannurTripPlan) {
                      var data = element;
                      if (place == element["place name"]) {
                        if (data != null) {
                          // Find a specific schedule
                          schedule = data["Trip plan"].firstWhere(
                            (element) =>
                                isTimeInRange(element['time'], userinputtime),
                            orElse: () => <String,
                                String>{}, // Return an empty map of the correct type
                          );

                          if (schedule!.isNotEmpty) {
                            print("Schedule found: $schedule");
                          } else {
                            print(
                                "No matching schedule found for $userinputtime.");
                          }
                        } else {
                          print("No data found for $place.");
                        }
                      }
                    }

                    if (schedule != null && schedule.isNotEmpty) {
                      startTime = extractEndTime(schedule['time']!);
                      setState(() {
                        scheduledTrips
                            .add(schedule!); // Add the schedule to the list
                      });
                    } else {
                      print("No valid schedule found for the selected place.");
                      // Handle cases where there's no valid schedule (e.g., skip the place or set a default time)
                    }
                  }
                } catch (e) {
                  print('An error occurred: $e');
                }
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
  Widget buildFilterSection(String title, List<String> options, Set<String> selectedOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: buildFilterChips(options, selectedOptions),
        ),
      ],
    );
  }
}
