import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' ;
import 'dart:async';
import 'JourneySuccess.dart';

//const fire = require("firebase");
// function postJourney(driverId, passengerId, pickupLocation, dropoffLocation, earning) {
//   // Generate a random journey ID
//   const journeyId = Math.floor(Math.random() * 1000000).toString();

//   // Create a reference to the "journeys" node in the database
//   const journeysRef = firebase.database().ref('journeys');

//   // Create a new journey object with the provided information
//   const newJourney = {
//     journeyId,
//     driverId,
//     passengerId,
//     pickupLocation,
//     dropoffLocation,
//     earning
//   };

//   // Push the new journey object to the "journeys" node
//   journeysRef.push(newJourney)
//     .then(() => {
//       console.log(`Journey ${journeyId} posted successfully`);
//     })
//     .catch((error) => {
//       console.error(`Error posting journey: ${error}`);
//     });
// }
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
late int pickup_index=0;
late int dropoff_index=0;
late List<LatLng> orderOfPickUp;
late List<LatLng> orderOfDropOff;
late List<PassengerMarker> markerList;
late FlutterMap flutterMap;
Timer? _timer;


void initState(){
  super.initState();
  // for (int i=0;i<widget.passengerDestinations.length;i++){
  //   Passenger p=new Passenger(widget.passengerLocations[i], widget.passengerDestinations[i]);
  //   passengerList.add(p);
  // }
   orderOfPickUp=sortLocations(widget.passengerLocations);
    orderOfDropOff=sortLocations(widget.passengerDestinations);
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
//Future.delayed(Duration(seconds: 3), addMarkers);
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

  // Timer.periodic(const Duration(milliseconds: 500), (timer) { 
  //   setState(() {
  //     widget.driverLat-=0.001;
  //     widget.driverLong-=0.001;
  //     addMarkers();

  //   });
  // });
  
  Timer.periodic(const Duration(seconds: 3), (timer) {
      
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
  //if(!orderOfPickup.emptY()){
  //  widget.driverLat = orderOFPickup[0].lat;
   //   widget.driverLong = orderOFPickup[0].long;
  //}
  // {
  //for i in Passengerlist
  //if lat_long = driver_lat_long:
  //  p.driverReached = true;
  // }
  //{else:
  //widget.driverLat = orderOFDropoff[0].lat;
   //   widget.driverLong = orderOFDropoff[0].long;
   // for i in Passengerlist
  //if lat_long = driver_lat_long:
  //  p.reachedDestination= true;
  // }}
  if(pickup_index<orderOfPickUp.length){
    widget.driverLat = orderOfPickUp[pickup_index].latitude;
    widget.driverLong = orderOfPickUp[pickup_index].longitude;
    for(Passenger p in passengerList){
      if(p.passengerFrom.latitude==widget.driverLat&&p.passengerFrom.longitude==widget.driverLong){
        p.driverReached = true;
      }
    }
    pickup_index+=1;
  }
  else if(pickup_index==orderOfPickUp.length&&dropoff_index<orderOfDropOff.length){
    widget.driverLat = orderOfDropOff[dropoff_index].latitude;
    widget.driverLong = orderOfDropOff[dropoff_index].longitude;
    for(Passenger p in passengerList){
      if(p.passengerTo.latitude==widget.driverLat&&p.passengerTo.longitude==widget.driverLong){
        p.reachedDestination = true;
      }
    }
    dropoff_index+=1;
  }
  else if (pickup_index==orderOfPickUp.length&&dropoff_index==orderOfDropOff.length){
    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          JourneySuccess(),
                    ));
  }
    
  markerList = [];
  markerList.add(PassengerMarker(LatLng(widget.driverLat,widget.driverLong),Colors.blue));
  for (Passenger p in passengerList) {
    if (!(p.reachedDestination == false&&p.driverReached==true)) {
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

   
    



    
   return Scaffold(
    appBar: AppBar(title: const Text("In transit")),
    body : flutterMap);
  }
}