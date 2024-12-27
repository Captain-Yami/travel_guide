import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MultipleLocationsMap extends StatefulWidget {
  @override
  _MultipleLocationsMapState createState() => _MultipleLocationsMapState();
}

class _MultipleLocationsMapState extends State<MultipleLocationsMap> {
  late GoogleMapController mapController;

  // Coordinates for three places in Kannur
  final LatLng place1 = LatLng(11.8678, 75.3610); // Payyambalam Beach
  final LatLng place2 = LatLng(11.8181, 75.3521); // Muzhappilangad Drive-in Beach
  final LatLng place3 = LatLng(11.9334, 75.3645); // Madayipara

  // Initialize markers
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.addAll({
      Marker(
        markerId: MarkerId('place1'),
        position: place1,
        infoWindow: InfoWindow(title: 'Payyambalam Beach'),
      ),
      Marker(
        markerId: MarkerId('place2'),
        position: place2,
        infoWindow: InfoWindow(title: 'Muzhappilangad Drive-in Beach'),
      ),
      Marker(
        markerId: MarkerId('place3'),
        position: place3,
        infoWindow: InfoWindow(title: 'Madayipara'),
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places in Kannur'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(11.8678, 75.3610), // Initial location centered on Kannur
          zoom: 10.0,
        ),
        markers: _markers,
      ),
    );
  }
}
