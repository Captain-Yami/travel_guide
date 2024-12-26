import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getDistanceOpenRouteService({
  required String apiKey,
  required List<double> origin,
  required List<double> destination,
}) async {
  final url = 'https://api.openrouteservice.org/v2/matrix/driving-car';

  // Prepare the request body
  final body = json.encode({
    "locations": [origin, destination], // Locations array
    "metrics": ["distance", "duration"], // Distance and duration
    "units": "km", // Units in kilometers
  });
  print(body);

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Authorization": apiKey, // API Key for authorization
      "Content-Type": "application/json",
    },
    body: body,
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final distance = data['distances'][0][1]; // Distance in kilometers
    final duration = data['durations'][0][1]; // Duration in seconds

    print('Distance: ${distance} km');
    print('Duration: ${duration / 60} minutes');
  } else {
    print('Error: ${response.body}');
  }
}