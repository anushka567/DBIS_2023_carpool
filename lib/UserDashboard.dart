import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'LocationPicker.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});


  void _navigateToLocationPicker(BuildContext context) async {

    LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
  if (permission != LocationPermission.whileInUse &&
      permission != LocationPermission.always) {
    // Handle location permissions not granted
    return ;
  }
}

Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);
double latitude = position.latitude;
double longitude = position.longitude;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker(initialLatitude: latitude,initialLongitude: longitude,)),
    );

    // Do something with the result
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Welcome user ")),
       body: Center(
        child: ElevatedButton(
          child: Text('Hire a Cab'),
          onPressed: () => _navigateToLocationPicker(context),
        ),
      ),);
  }
}