import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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
  final url = 'https://apis.mapmyindia.com/advancedmaps/v1/$apiKey/distance_matrix/driving/$origin;$destination';

  final response = await http.get(Uri.parse(url));

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
