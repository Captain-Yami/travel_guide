import 'dart:convert';
import 'package:http/http.dart' as http;

// Function with named parameters and error handling using try-catch
Future<Map<String, dynamic>> getRecommendedPlaces({
  required List<double> currentLocation,
  required int budget,
  required double availableTime,
  required String type,
  required double maxDistance,
}) async {
  try {
    // Prepare the input data with the named parameters
    final inputData = {
      "current_location": currentLocation,
      "budget": budget,
      "available_time": availableTime,
      "type": type,
      "max_distance": maxDistance,
    };

    // Set the URL for the request
    final url = Uri.parse('https://3c31-2401-4900-32f4-9b97-9406-f936-1548-ea43.ngrok-free.app/recommend');

    // Send the POST request
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(inputData),
    );
                
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response JSON and return it
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;  // Return the parsed response data
    } else {
      // If the status code is not 200, throw an exception with an error message
      throw Exception('Failed to load recommendations. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any error (network issues, invalid JSON, etc.)
    print('Error occurred: $e');
    rethrow;  // Optionally rethrow the error if you want it to be handled higher up
  }
}

