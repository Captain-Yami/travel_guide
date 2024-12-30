import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_guide/api.dart';
import 'package:travel_guide/data.dart';
import 'package:travel_guide/distance_calculator.dart';
import 'package:travel_guide/timecomparison.dart';
import 'package:geocoding/geocoding.dart';

class Start extends StatefulWidget {
  Start({super.key, required this.userLocation});

  Map<String, double> userLocation;

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  // Filter options with selection states
  TextEditingController _addressController = TextEditingController();
   Future<void> getCoordinatesFromAddress() async {
    try {
  String address = _addressController.text;
  if (address.isEmpty) {
    print('Address is empty');
    return;
  }
  print('===============================');
  List<Location> locations = await locationFromAddress(_addressController.text);
  print(locations);
  setState(() {
    if (locations.isNotEmpty) {
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    print('Latitude: $latitude, Longitude: $longitude');
    setState(() {
      widget.userLocation['latitude'] = latitude;
      widget.userLocation['longitude'] = longitude;
    });
  } else {
    print('No locations found for this address.');
  }
    
  });
  
} catch (e) {
  print('Error occurred while fetching coordinates: $e');
}

  }


  String? selectedBudget;
  String? selectedTime;
  String? selectedPlace;
  String? selectedDistance;

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

  int _extractMinBudget(String? range) {
    if (range == null) return 0;
    return int.parse(range.split('-').first);
  }

  double _convertTimeToHours(String? time) {
    if (time == null) return 0.0;
    return time.contains('Hour')
        ? double.parse(time.replaceAll(' Hour', '').replaceAll(':', '.'))
        : 0.0;
  }

  double _extractMaxDistance(String? range) {
    if (range == null) return 0.0;
    return double.parse(range.split('-').last.replaceAll(' Km', ''));
  }


  List<Widget> buildFilterChips(
      List<String> options, Set<String> selectedOptions) {
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

  Widget buildChoiceChipSection(
      String title, List<String> options, Function(String?) onSelected) {
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
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: option == selectedBudget ||
                  option == selectedTime ||
                  option == selectedPlace ||
                  option == selectedDistance,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) onSelected(option);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

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
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Enter the satarting location',
                    border: OutlineInputBorder(),
                  ),
                ),
                 // Add a button to trigger the geocoding
                ElevatedButton(
                  onPressed: getCoordinatesFromAddress, 
                  child: Text('Get Coordinates'),
                ),
                // Budget Filter
                buildChoiceChipSection(
                    'Budget', budgetOptions, (value) => selectedBudget = value),
                const SizedBox(height: 10),
                buildChoiceChipSection(
                    'Time', timeOptions, (value) => selectedTime = value),
                const SizedBox(height: 10),
                buildChoiceChipSection(
                    'Place', placeOptions, (value) => selectedPlace = value),
                const SizedBox(height: 10),
                buildChoiceChipSection(
                    'Distance', kmOptions, (value) => selectedDistance = value),
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
                  if (selectedBudget != null &&
                      selectedTime != null &&
                      selectedPlace != null &&
                      selectedDistance != null) {
                    int budget = _extractMinBudget(selectedBudget);
                    double time = _convertTimeToHours(selectedTime);
                    double distance = _extractMaxDistance(selectedDistance);
                    String type = selectedPlace!;

                    print('Budget: $budget');
                    print('Time: $time');
                    print('Distance: $distance');
                    print('Type: $type');
                    

                    // Fetch AI-recommended places
                    var aidata = await getRecommendedPlaces(
                      currentLocation: [
                        widget.userLocation['latitude']!,
                        widget.userLocation['longitude']!
                      ],
                      budget: budget,
                      availableTime: time,
                      maxDistance: distance,
                      type: type,
                    );

                    List<dynamic> recommendedPlaces =
                        aidata['recommended_places'];
                    List<dynamic> selectedPlaces = [];

                    // Fetch up to 4 places
                    for (int i = 0;
                        i < recommendedPlaces.length && i < 4;
                        i++) {
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
                        print(
                            "No valid schedule found for the selected place.");
                        // Handle cases where there's no valid schedule (e.g., skip the place or set a default time)
                      }
                    }
                  } else {
                    print('Please select all filters.');
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
  Widget buildFilterSection(
      String title, List<String> options, Set<String> selectedOptions) {
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
