import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
// Function to fetch top 5 journeys for a given driver ID
void fetchTopJourneys(String driverId) {
  final journeysRef = FirebaseDatabase.instance.reference().child('journeys');

  final driverJourneysQuery = journeysRef
      .orderByChild('driverId')
      .equalTo(driverId)
      .orderByChild('earning')
      .limitToLast(5);

  driverJourneysQuery.onValue.listen((event) {
    final DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      final List<dynamic> journeysList = snapshot.value.values.toList();

      journeysList.sort((a, b) => b['earning'].compareTo(a['earning']));

      final List<dynamic> topJourneys = journeysList.sublist(0, 5);

      print('Top 5 journeys for driver $driverId:');
      topJourneys.forEach((journey) {
        final pickupLat = journey['pickupLocation']['lat'];
        final pickupLng = journey['pickupLocation']['lng'];
        final dropoffLat = journey['dropoffLocation']['lat'];
        final dropoffLng = journey['dropoffLocation']['lng'];
        final earning = journey['earning'];

        print('Journey ID: ${journey['journeyId']}, '
            'Pickup: ($pickupLat, $pickupLng), '
            'Drop-off: ($dropoffLat, $dropoffLng), '
            'Fare: $earning');
      });
    } else {
      print('No journeys found for driver $driverId');
    }
  }, onError: (error) {
    print('Error fetching journeys: $error');
  });
}



// Function to fetch top 5 journeys for a given user ID
void fetchTopJourneysForUser(String userId) {
  final journeysRef = FirebaseDatabase.instance.reference().child('journeys');

  final userJourneysQuery = journeysRef
      .orderByChild('passengerId')
      .equalTo(userId)
      .orderByChild('earning')
      .limitToLast(5);

  userJourneysQuery.onValue.listen((event) {
    final DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      final List<dynamic> journeysList = snapshot.value.values.toList();

      journeysList.sort((a, b) => b['earning'].compareTo(a['earning']));

      final List<dynamic> topJourneys = journeysList.sublist(0, 5);

      print('Top 5 journeys for user $userId:');
      topJourneys.forEach((journey) {
        final pickupLat = journey['pickupLocation']['lat'];
        final pickupLng = journey['pickupLocation']['lng'];
        final dropoffLat = journey['dropoffLocation']['lat'];
        final dropoffLng = journey['dropoffLocation']['lng'];
        final earning = journey['earning'];

        print('Journey ID: ${journey['journeyId']}, '
            'Pickup: ($pickupLat, $pickupLng), '
            'Drop-off: ($dropoffLat, $dropoffLng), '
            'Fare: $earning');
      });
    } else {
      print('No journeys found for user $userId');
    }
  }, onError: (error) {
    print('Error fetching journeys: $error');
  });
}




// Function to post a new journey to the Firebase Realtime Database
void postJourneyDetails(String driverId, String userId, double pickupLat, double pickupLng, double dropoffLat, double dropoffLng) {
  final journeysRef = FirebaseDatabase.instance.reference().child('journeys');

  // Generate a random journey ID
  final journeyId = Random().nextInt(1000000);

  // Generate a random fare
  final fare = Random().nextDouble() * 100;

  // Create a new journey object with the provided details
  final newJourney = {
    'journeyId': journeyId,
    'driverId': driverId,
    'passengerId': userId,
    'pickupLocation': {
      'lat': pickupLat,
      'lng': pickupLng,
    },
    'dropoffLocation': {
      'lat': dropoffLat,
      'lng': dropoffLng,
    },
    'earning': fare,
  };

  // Post the new journey object to the Firebase Realtime Database
  journeysRef.child(journeyId.toString()).set(newJourney).then((value) {
    print('Journey posted successfully');
  }).catchError((error) {
    print('Failed to post journey: $error');
  });
}



// Function to post a new driver to the Firebase Realtime Database
void postDriverDetails(String driverId, double driverLat, double driverLng) {
  final driversRef = FirebaseDatabase.instance.reference().child('drivers');

  // Create a new driver object with the provided details
  final newDriver = {
    'driverId': driverId,
    'driverLocation': {
      'lat': driverLat,
      'lng': driverLng,
    },
    'status': 'idle',
  };

  // Post the new driver object to the Firebase Realtime Database
  driversRef.child(driverId).set(newDriver).then((value) {
    print('Driver posted successfully');
  }).catchError((error) {
    print('Failed to post driver: $error');
  });
}

void postUserDetails(String userId, double userLat, double userLng) {
  final usersRef = FirebaseDatabase.instance.reference().child('users');

  // Create a new user object with the provided details
  final newUser = {
    'userId': userId,
    'userLocation': {
      'lat': userLat,
      'lng': userLng,
    },
    'status': 'waiting',
  };

  // Post the new user object to the Firebase Realtime Database
  usersRef.child(userId).set(newUser).then((value) {
    print('User posted successfully');
  }).catchError((error) {
    print('Failed to post user: $error');
  });
}



// Function to fetch the nearest 5 waiting passengers to the driver's location
void fetchNearestWaitingPassengers(Position driverLocation, String driverId) {
  final usersRef = FirebaseDatabase.instance.reference().child('users');

  // Build a query to filter the users table for waiting passengers
  final waitingPassengersQuery = usersRef.orderByChild('status').equalTo('waiting');

  // Attach a listener to the query to receive updates when new waiting passengers are added
  waitingPassengersQuery.onChildAdded.listen((event) {
    final userId = event.snapshot.key;
    final userLocation = event.snapshot.value['userLocation'];
    final userLat = userLocation['lat'] as double;
    final userLng = userLocation['lng'] as double;

    // Calculate the distance between the driver and the passenger using the Haversine formula
    final distance = Geolocator.distanceBetween(driverLocation.latitude, driverLocation.longitude, userLat, userLng);

    // Create a new object with the passenger details and the distance to the driver
    final passenger = {
      'userId': userId,
      'userLocation': userLocation,
      'distance': distance,
    };

    // Add the passenger object to a list of nearby waiting passengers
    nearbyWaitingPassengers.add(passenger);

    // Sort the list of nearby waiting passengers by distance to the driver
    nearbyWaitingPassengers.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Keep only the 5 nearest waiting passengers
    nearbyWaitingPassengers = nearbyWaitingPassengers.sublist(0, 5);

    // Log the list of nearby waiting passengers
    print('Nearest waiting passengers:');
    print(nearbyWaitingPassengers);
  });
}





// Function to change the status of a list of users from oldState to newState
void changeUserStatus(List<String> userIds, String oldState, String newState) {
  final usersRef = FirebaseDatabase.instance.reference().child('users');

  // Loop through the list of user IDs and update each user's status in the users table
  for (final userId in userIds) {
    usersRef.child(userId).once().then((snapshot) {
      final userStatus = snapshot.value['status'] as String;
      if (userStatus == oldState) {
        usersRef.child(userId).child('status').set(newState);
      }
    });
  }
}


class Journey {
  final String journeyId;
  final String userId;
  final String driverId;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final double fare;

  Journey(this.journeyId, this.userId, this.driverId, this.pickupLatitude,
      this.pickupLongitude, this.dropoffLatitude, this.dropoffLongitude, this.fare);

  factory Journey.fromSnapshot(DataSnapshot snapshot) {
    return Journey(
      snapshot.key,
      snapshot.value['userId'],
      snapshot.value['driverId'],
      snapshot.value['pickup']['latitude'],
      snapshot.value['pickup']['longitude'],
      snapshot.value['dropoff']['latitude'],
      snapshot.value['dropoff']['longitude'],
      snapshot.value['fare']
    );
  }
}

// Function to find the driver that has been assigned to a particular user
Future<String> findDriverForUser(String userId) async {
  final journeysRef = FirebaseDatabase.instance.reference().child('journeys');

  // Query the journeys table to find the newest entry corresponding to the user
  final snapshot = await journeysRef
      .orderByChild('userId')
      .equalTo(userId)
      .limitToLast(1)
      .once();

  // Get the driver ID from the journey record
  final journey = Journey.fromSnapshot(snapshot.value);
  return journey.driverId;
}

























