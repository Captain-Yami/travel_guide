
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationSearchScreen extends StatefulWidget {
  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _latitude = "";
  String _longitude = "";
  String _errorMessage = "";

  Future<void> getCoordinates(String location) async {
    final String apiKey = 'ccc08d8bd6a4487fa52aa6fd4dc0794a'; // Replace with your OpenCage API key
    final String url =
        'https://api.opencagedata.com/geocode/v1/json?q=${Uri.encodeComponent(location)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final lat = data['results'][0]['geometry']['lat'];
          final lng = data['results'][0]['geometry']['lng'];
          setState(() {
            _latitude = lat.toString();
            _longitude = lng.toString();
            _errorMessage = "";
          });
        } else {
          setState(() {
            _errorMessage = "Location not found!";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Location",
                hintText: "e.g., New York, Eiffel Tower",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  getCoordinates(_controller.text);
                }
              },
              child: Text("Get Coordinates"),
            ),
            SizedBox(height: 16),
            if (_latitude.isNotEmpty && _longitude.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Latitude: $_latitude", style: TextStyle(fontSize: 16)),
                  Text("Longitude: $_longitude", style: TextStyle(fontSize: 16)),
                ],
              ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}