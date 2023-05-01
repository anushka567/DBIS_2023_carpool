import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' ;
import 'dart:async';


class Passenger{
  late LatLng passengerFrom;
  late LatLng passengerTo;
  late PassengerMarker marker;
  bool driverReached=false;
  bool reachedDestination=false;

  Passenger(LatLng from,LatLng to,PassengerMarker mark){
    this.passengerFrom=from;
    this.passengerTo=to;
    this.marker=mark;
  }

}

class PassengerMarker{
  late LatLng location;
  late Color color;

   PassengerMarker(LatLng loc, Color col){
    this.location=loc;
    this.color=col;

   }

}


class DriveFromTo extends StatefulWidget {

  late double driverLat;
  late double driverLong;
  final List<LatLng> passengerLocations;
  final List<LatLng> passengerDestinations; 
 
  DriveFromTo({
    Key? key,
    required this.driverLat,
    required this.driverLong,
     required this.passengerLocations,
    required this.passengerDestinations,
  }) : super(key: key);

  @override
  State<DriveFromTo> createState() => _DriveFromToState();
}



class _DriveFromToState extends State<DriveFromTo> {
late List<Passenger> passengerList;
late List<PassengerMarker> markerList;
late FlutterMap flutterMap;
Timer? _timer;


void initState(){
  super.initState();
  // for (int i=0;i<widget.passengerDestinations.length;i++){
  //   Passenger p=new Passenger(widget.passengerLocations[i], widget.passengerDestinations[i]);
  //   passengerList.add(p);
  // }
  passengerList = [];
    markerList = [];
    for (int i = 0; i < widget.passengerDestinations.length; i++) {
      PassengerMarker pm =
          PassengerMarker(widget.passengerLocations[i], Colors.red);
      Passenger p =
          new Passenger(widget.passengerLocations[i], widget.passengerDestinations[i], pm);
      passengerList.add(p);
    }
 addMarkers();

 flutterMap = FlutterMap(
        options: MapOptions(
            center: LatLng(widget.driverLat, widget.driverLong), zoom: 14),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            
             
            markers: markerList.map((m) {
              
              return Marker(
                  point: m.location,
                  builder: (ctx) => Container(
                        child: Icon(m.color == Colors.blue? Icons.car_rental:
                          Icons.location_pin,
                            size: 40.0, color: m.color),
                      ));
            }).toList(),
           
            
          )
        ]);

  Timer.periodic(const Duration(milliseconds: 500), (timer) { 
    setState(() {
      widget.driverLat-=0.001;
      widget.driverLong-=0.001;
      addMarkers();

    });
  });
  
  Timer.periodic(const Duration(seconds: 5), (timer) {
      
    setState(() {
      addMarkers();
    }); 
    //I now want to animate only marker
    });



  
}


void dropOffPassenger(Passenger p){
  setState(() {
    p.reachedDestination=true;
    passengerList.remove(p);
  });

}

void pickUpPassenger(Passenger p){
  setState(() {
    p.driverReached=true;
    passengerList.add(p);
    
  });
}


//we need to display the marker for those for which driverReached = false. or destinationreached =true;
void addMarkers(){
  markerList = [];
  markerList.add(PassengerMarker(LatLng(widget.driverLat,widget.driverLong),Colors.blue));
  for (Passenger p in passengerList) {
    if (p.reachedDestination == false) {
      markerList.add(p.marker);
    }
  }
  flutterMap = FlutterMap(
        options: MapOptions(
            center: LatLng(widget.driverLat, widget.driverLong), zoom: 14),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            
             
            markers: markerList.map((m) {
              
              return Marker(
                  point: m.location,
                  builder: (ctx) => Container(
                        child: Icon(m.color == Colors.blue? Icons.car_rental:
                          Icons.location_pin,
                            size: 40.0, color: m.color),
                      ));
            }).toList(),
           
            
          )
        ]);
  setState(() {});
}


double getDistanceBetween(LatLng initPosition,LatLng finalPos){
  //return the distance between the two points
  const earthRadius = 6371000; // in meters
  final dLat = (finalPos.latitude - initPosition.latitude)*pi/180;
  final dLon = (finalPos.longitude - initPosition.longitude)*pi/180;
  final lat1 = (initPosition.latitude)*pi/180;
  final lat2 = (finalPos.latitude)*pi/180;

  final a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final distance = earthRadius * c;
  return distance;
}

List<LatLng> sortLocations(List<LatLng> locations){
  LatLng driverPos= LatLng(widget.driverLat, widget.driverLong);
  locations.sort((a, b) {
    final distanceA = getDistanceBetween(driverPos, a);
    final distanceB = getDistanceBetween(driverPos, b);
    return distanceA.compareTo(distanceB);
  });
  return locations;
}



  @override
  Widget build(BuildContext context) {

    List<LatLng> orderOfPickUp=sortLocations(widget.passengerLocations);
    List<LatLng> orderOfDropOff=sortLocations(widget.passengerDestinations);
    



    
   return Scaffold(
    appBar: AppBar(title: const Text("In transit")),
    body : flutterMap);
  }
}