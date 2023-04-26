import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'PassengerPicker.dart';
import 'Login.dart';
class Journey {
  final String journeyId;
  final String pickupLocation;
  final String dropoffLocation;
  final double cost;

  Journey(
      {required this.journeyId,
      required this.pickupLocation,
      required this.dropoffLocation,
      required this.cost});
}

class DriverDashboardPage extends StatelessWidget {
  const DriverDashboardPage({super.key});
  


  void _navigateToPassengerPicker(BuildContext context) async {

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
      MaterialPageRoute(builder: (context) => PassengerPicker(initialLatitude: latitude,initialLongitude: longitude,)),
    );

    // Do something with the result
  }

   void _logout(BuildContext context) {
    // Perform logout operation here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }



   
  @override
  Widget build(BuildContext context) {
    List<Journey> journeyList = [      Journey(journeyId: 'J001', pickupLocation: 'New York', dropoffLocation: 'Los Angeles', cost: 250.0),      Journey(journeyId: 'J002', pickupLocation: 'San Francisco', dropoffLocation: 'Las Vegas', cost: 180.0),      Journey(journeyId: 'J003', pickupLocation: 'Chicago', dropoffLocation: 'Miami', cost: 350.0),    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Driver!'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Recent Journeys and Earnings',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
             SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Journey ID'),
                  ),
                  DataColumn(
                    label: Text('Pickup Location'),
                  ),
                  DataColumn(
                    label: Text('Dropoff Location'),
                  ),
                  DataColumn(
                    label: Text('Earning'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  journeyList.length,
                  (index) => DataRow(
cells: [
                      DataCell(Text(journeyList[index].journeyId)),
                      DataCell(Text(journeyList[index].pickupLocation)),
                      DataCell(Text(journeyList[index].dropoffLocation)),
                      DataCell(Text(journeyList[index].cost.toString())),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToPassengerPicker(context);
        },
         child: const Icon(Icons.car_rental),
      ),
    );

       
  }            
  
}
