import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'FindDrivers.dart';
class LocationPicker extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const LocationPicker({
    Key? key,
   required this.initialLatitude,
    required this.initialLongitude,}) : super(key : key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String address="";
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body : OpenStreetMapSearchAndPick(
        center: LatLong(widget.initialLatitude, widget.initialLongitude),
        buttonColor: Colors.blue,
        buttonText: 'Select as destination',
        onPicked: (pickedData) {
          //get the latitude and longitide of thepicked dtaa
          // print(pickedData.latLong.longitude);
             final latitude = pickedData.latLong.latitude;
          final longitude = pickedData.latLong.longitude;

          // Navigate to a new page with the latitude and longitude data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>MapPage(
                startLatitude: widget.initialLatitude,
                startLongitude: widget.initialLongitude,
                // endLatitude: latitude,
                // endLongitude: longitude,
              ),
            ),
          );
        },
        
         )

    );
  }
}


