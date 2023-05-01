import 'package:cabshare/DriverDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'drive_from_to.dart';

class PassengerPicker extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const PassengerPicker({
    Key? key,
    required this.initialLatitude,
    required this.initialLongitude,
  }) : super(key: key);

  @override
  State<PassengerPicker> createState() => _PassengerPickerState();
  // fetchNearestWaitingPassengers(FirebaseAuth.instance.currentUser.loc, FirebaseAuth.instance.currentUser)
  // changeUserStatus(FirebaseAuth.instance.currentUser, "init", "waiting") Commented for demo
}

class _PassengerPickerState extends State<PassengerPicker> {
  final List<LatLng> _passengerLocations = [
    LatLng(19.1136, 72.9060),
    LatLng(19.1176, 72.9160),
    LatLng(19.1126, 72.9080),
  ];

  final List<LatLng> _passengerDestinations = [
    LatLng(19.1106, 72.9062),
    LatLng(19.1116, 72.9163),
    LatLng(19.1156, 72.9085),
  ];




  void startJourney(BuildContext context){
    // postJourneyDetails(_driverId, _userId, _pickupLat, _pickupLng, _dropoffLat, _dropoffLng) 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  DriveFromTo(driverLat: widget.initialLatitude,driverLong: widget.initialLongitude,
    passengerLocations: _passengerLocations,passengerDestinations: _passengerDestinations,)),
    );
   
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Picker'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.initialLatitude, widget.initialLongitude),
          zoom: 12.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
           CircleLayer(circles: [
            CircleMarker(
              point: LatLng(widget.initialLatitude,widget.initialLongitude),
              radius:  50,
              color: Colors.green.withOpacity(0.3),
              borderColor: Colors.green,
              borderStrokeWidth: 2,
            ),
          ]),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(widget.initialLatitude, widget.initialLongitude),
                builder: (ctx) => const Icon(
                  Icons.directions_car,
                  color: Color.fromARGB(255, 233, 30, 30),
                  size: 40.0,
                ),
              ),
              for (var location in _passengerLocations)
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: location,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 40.0,
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){startJourney(context);}, 
      child: const Text('Drive'), ),
    );
  }
}
