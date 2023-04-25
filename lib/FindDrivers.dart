import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final double startLatitude;
  final double startLongitude;

  const MapPage({
    Key? key,
    required this.startLatitude,
    required this.startLongitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> _driverPositions = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Load initial driver positions
    _loadDriverPositions();

    // Setup timer to reload driver positions every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _loadDriverPositions();
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel timer
    _timer?.cancel();
  }

  Future<void> _loadDriverPositions() async {
    // Make API call to get driver positions
    
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

    if (response.statusCode == 200) {
      // Parse response JSON to get driver positions
      final data = jsonDecode(response.body);
      final driverPositions = List<Map<String, dynamic>>.from(data['positions']);

      // Update driver positions list
      setState(() {
        _driverPositions = driverPositions.map((position) => LatLng(position['latitude'], position['longitude'])).toList();
      });
    } else {
      throw Exception('Failed to load driver positions');
    }
   
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.startLatitude, widget.startLongitude),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Marker for original point
              Marker(
                point: LatLng(widget.startLatitude, widget.startLongitude),
                builder: (context) => Icon(Icons.location_on,color: Colors.red,),
              ),
              // Marker for driver positions
              ..._driverPositions.map((position) => Marker(
                point: position,
                builder: (context) => Icon(Icons.directions_car,color: Colors.blue,),
              )),
            ],
          ),
          PolylineLayer(
            polylines: [
              // Polyline connecting original point and driver positions
              Polyline(
                points: [
                  LatLng(widget.startLatitude, widget.startLongitude),
                  ..._driverPositions,
                ],
                color: Colors.blue,
                strokeWidth: 2.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}