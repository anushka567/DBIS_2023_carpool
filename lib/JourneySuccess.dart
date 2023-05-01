

import 'dart:async';
import 'package:cabshare/DriverDashboard.dart';
import 'package:flutter/material.dart';

class JourneySuccess extends StatefulWidget {
  @override
  _JourneySuccessState createState() => _JourneySuccessState();
}

class _JourneySuccessState extends State<JourneySuccess> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown == 0) {
        timer.cancel();
        redirectToDashboard();
      }
    });
  }

  void redirectToDashboard() {
    //Navigator.pushReplacementNamed(context, '/dashboard');
    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DriverDashboardPage(),
                    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Journey successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Redirecting to dashboard in $_countdown seconds...',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}