import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:travel_guide/api.dart';
import 'package:travel_guide/data.dart';
import 'package:travel_guide/distance_calculator.dart';
import 'package:travel_guide/timecomparison.dart';
import 'package:travel_guide/serach_location.dart';
import 'package:http/http.dart' as http;

class Start extends StatefulWidget {
  Start({super.key, required this.userLocation});

  Map<String, double> userLocation;

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  // Filter options with selection states
  TextEditingController _addressController = TextEditingController();
  String _latitude = "";
  String _longitude = "";
  String _errorMessage = "";

  String? selectedBudget;
  String? selectedTime;
  String? selectedPlace;
  String? selectedDistance;
  String? selectedStartTime;

  final List<String> startTimeOptions = [
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
  ];

  final List<String> budgetOptions = [
    '0-100',
    '100-200',
    '200-300',
    '300-400',
    '400-500',
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
    '30-40 Km',
    '40-50 Km',
    '50-60 Km',
    '60-70 Km',
    '70-80 Km',
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
              selected: option == selectedStartTime ||
                  option == selectedBudget ||
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

  Future<Map<String, double>> getCoordinates(String location) async {
    final String apiKey =
        'ccc08d8bd6a4487fa52aa6fd4dc0794a'; // Replace with your OpenCage API key
    final String url =
        'https://api.opencagedata.com/geocode/v1/json?q=${Uri.encodeComponent(location)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final double lat = data['results'][0]['geometry']['lat'];
          final double lng = data['results'][0]['geometry']['lng'];
          return {'latitude': lat, 'longitude': lng};
        } else {
          throw Exception("Location not found!");
        }
      } else {
        throw Exception("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
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
                    border: OutlineInputBorder(),
                    labelText: "Enter Location",
                    hintText: "e.g., New York, Eiffel Tower",
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String address = _addressController.text;

                    if (address.isEmpty) {
                      print('Please enter an address.');
                      return;
                    }

                    try {
                      // Fetch the latitude and longitude using getCoordinates
                      Map<String, double> coordinates =
                          await getCoordinates(address);

                      // Use the coordinates
                      print(
                          'Latitude: ${coordinates['latitude']}, Longitude: ${coordinates['longitude']}');

                      setState(() {
                        widget.userLocation =
                            coordinates; // Update userLocation in the widget
                      });

                      // Optionally, use these coordinates for further processing
                      var latitude = coordinates['latitude'];
                      var longitude = coordinates['longitude'];

                      // Example: Print or pass these values into another function
                      print(
                          'Coordinates received: Latitude - $latitude, Longitude - $longitude');

                      // Use the coordinates with any other logic
                      // e.g., Pass them to other functions or make API calls
                    } catch (e) {
                      print('Error fetching coordinates: $e');
                    }
                  },
                  child: const Text('Get Coordinates'),
                ),

                SizedBox(height: 16),
                if (_latitude.isNotEmpty && _longitude.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Latitude: $_latitude",
                          style: TextStyle(fontSize: 16)),
                      Text("Longitude: $_longitude",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                // Budget Filter
                buildChoiceChipSection('Start Time', startTimeOptions,
                    (value) => selectedStartTime = value),
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
                      selectedDistance != null &&
                      selectedStartTime != null) {
                    int budget = _extractMinBudget(selectedBudget);
                    double time = _convertTimeToHours(selectedTime);
                    double distance = _extractMaxDistance(selectedDistance);
                    String type = selectedPlace!;

                    print('Budget: $budget');
                    print('Time: $time');
                    print('Distance: $distance');
                    print('Type: $type');

                    // Ensure coordinates are available
                    if (widget.userLocation['latitude'] != null &&
                        widget.userLocation['longitude'] != null) {
                      double latitude = widget.userLocation['latitude']!;
                      double longitude = widget.userLocation['longitude']!;

                      print('Using Latitude: $latitude, Longitude: $longitude');

                      // Fetch AI-recommended places
                      var aidata = await getRecommendedPlaces(
                        currentLocation: [latitude, longitude],
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

                      var startlatitudefirst = latitude;
                      var startlongitudefirst = longitude;
                      var startTime = selectedStartTime;

                      // Process the recommended places
                      for (var e in selectedPlaces) {
                        var distance = calculateDistance(
                            startlatitudefirst,
                            startlongitudefirst,
                            e['Location']['Latitude'],
                            e['Location']['Longitude']);

                        var userinputtime =
                            getTimeFromDist(distance, startTime!);

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
                                (element) => isTimeInRange(
                                    element['time'], userinputtime),
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
                        }
                      }
                    } else {
                      print('User location not set. Please enter an address.');
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

