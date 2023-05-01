import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MyMapScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const MyMapScreen({
    Key? key,
    required this.initialLatitude,
    required this.initialLongitude,
  }) : super(key: key);

  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: widget.initialLatitude,
        longitude: widget.initialLongitude,
      ),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: controller,
        trackMyPosition: true,
        initZoom: 12,
        minZoomLevel: 8,
        maxZoomLevel: 19,
        stepZoom: 1.0,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 48,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: const RoadOption(
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
          defaultMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}