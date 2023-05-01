import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'LocationPicker.dart';
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

class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});
  


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
    // findDriverForUser(_userId)
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
    List<Journey> journeyList = [     Journey(journeyId: 'J001', pickupLocation: 'Powai', dropoffLocation: 'Andheri', cost: 250.0),      Journey(journeyId: 'J002', pickupLocation: 'Andheri', dropoffLocation: 'Bandra', cost: 180.0),      Journey(journeyId: 'J003', pickupLocation: 'Bandra', dropoffLocation: 'Vikhroli', cost: 350.0),    ];
  
    //fetchTopJourneysForUser(FirebaseAuth.instance.currentUser) //Commented for demo  
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome User!'),
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
                'Recent Journeys',
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
                    label: Text('Cost'),
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
          _navigateToLocationPicker(context);
        },
         child: const Icon(Icons.car_rental),
      ),
    );

       
  }            
  
}