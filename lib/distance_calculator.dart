import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:travel_guide/home/user/screen/start.dart';
import 'package:intl/intl.dart';

double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude) {
  var location=  Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );
  print(location);
  return location / 1000;
}






Future<double> getRouteDistanceMapMyIndia(String origin, String destination, String apiKey) async {
  // Construct the API URL
  final url = 'https://apis.mapmyindia.com/advancedmaps/v1/$apiKey/distance_matrix/driving/11.854357300022897,75.37240431881564;$destination';

  final response = await http.get(Uri.parse(url));

print('rhidu krishna');

print(response.statusCode);
print(response.body);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Extract the distance in meters
    final distanceInMeters = data['routes'][0]['summary']['distance'];
    return distanceInMeters / 1000; // Convert meters to kilometers
  } else {
    throw Exception('Failed to fetch distance: ${response.body}');
  }
}


String getTimeFromDist(double distance, String startTime) {
  int timeToAddInMinutes = 0;

  // Check the distance and determine the time to add
  if (distance < 10) {
    timeToAddInMinutes = 20; // Add 20 minutes for distances less than 10 km
  } else if (distance >= 10 && distance < 20) {
    timeToAddInMinutes = 30; // Add 30 minutes for distances between 10 and 20 km
  } else if (distance >= 20 && distance < 30) {
    timeToAddInMinutes = 40; // Add 40 minutes for distances between 20 and 30 km
  } else if (distance >= 30) {
    timeToAddInMinutes = 60; // Add 60 minutes for distances greater than or equal to 30 km
  }

  // Parse the start time in 7:00 AM format
  DateTime startDateTime = DateTime.now();
  final timeParts = RegExp(r'(\d+):(\d+) (AM|PM)').firstMatch(startTime);
  if (timeParts != null) {
    int hour = int.parse(timeParts.group(1)!);
    int minute = int.parse(timeParts.group(2)!);
    String period = timeParts.group(3)!;

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    startDateTime = DateTime(
      startDateTime.year,
      startDateTime.month,
      startDateTime.day,
      hour,
      minute,
    );
  } else {
    throw ArgumentError('Invalid time format. Use 7:00 AM format.');
  }

  // Add the calculated duration (in minutes) to the start time
  DateTime newTime = startDateTime.add(Duration(minutes: timeToAddInMinutes));

  // Convert the hour to 12-hour format
  int hourIn12HourFormat = newTime.hour % 12;
  if (hourIn12HourFormat == 0) hourIn12HourFormat = 12; // Midnight and noon are 12

  // Determine AM/PM
  String amPm = newTime.hour >= 12 ? 'PM' : 'AM';

  // Format the time in 12-hour format with AM/PM
  String formattedTime = "${hourIn12HourFormat}:${newTime.minute.toString().padLeft(2, '0')} $amPm";

  return formattedTime;
}
