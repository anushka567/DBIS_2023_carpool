import 'dart:async';

import 'package:cabshare/user_pay_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'user_pay_driver.dart';
import 'DriverDashboard.dart';

class MapPage extends StatefulWidget {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const MapPage({
    Key? key,
    required this.startLatitude,
    required this.startLongitude,
     required this.endLatitude,
    required this.endLongitude,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> _passengerPositions = [];
  bool _reached =false ;
  Timer? _timer;
  



Future<void> showNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    channelDescription: 'channelDescription',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
  );
  
  const details = NotificationDetails(
    android: androidDetails,
   
  );
  await FlutterLocalNotificationsPlugin().show(
    0,
    'Ride Complete',
    'You have reached your destination.',
    details,
  );
}

  @override
  void initState() {
    super.initState();
    // Load initial passenger positions
    // _loadpassengerPositions();
    _passengerPositions=[LatLng(widget.endLatitude,widget.endLongitude)];
  // _reached = true;
    // Setup timer to reload passenger positions every 5 minutes
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // _loadpassengerPositions();
      setState(() {
        
         _reached=true;
      });
     
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel timer
    _timer?.cancel();
  }

  Future<void> _loadpassengerPositions() async {
    // Make API call to get passenger positions
    
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

    if (response.statusCode == 200) {
      // Parse response JSON to get passenger positions
      final data = jsonDecode(response.body);
      final passengerPositions = List<Map<String, dynamic>>.from(data['positions']);

      // Update passenger positions list
      setState(() {
        _passengerPositions = passengerPositions.map((position) => LatLng(position['latitude'], position['longitude'])).toList();
      });
    } else {
      throw Exception('Failed to load passenger positions');
    }
   
   
  }

  @override
  Widget build(BuildContext context) {
    if(_reached){
    
  showNotification();
 // return ReviewForm(passengerId: '00000', userId: 'hhhhhh');
 return DriverDashboardPage();


    
    }
    return   Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body:  FlutterMap(
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
                builder: (context) => Icon(Icons.directions_car,color: Colors.red,),
              ),
              // Marker for passenger positions
              ..._passengerPositions.map((position) => Marker(
                point: position,
                builder: (context) => Icon(Icons.location_on,color: Colors.blue,),
              )),
            ],
          ),
          PolylineLayer(
            polylines: [
              // Polyline connecting original point and passenger positions
              Polyline(
                points: [
                  LatLng(widget.startLatitude, widget.startLongitude),
                  ..._passengerPositions,
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