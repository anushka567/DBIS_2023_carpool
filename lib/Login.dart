import 'package:flutter/material.dart';
import 'driver_user_Login.dart';
import 'Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isDriver = false;

  Widget _buildLoginSection() {
    if (_isDriver) {
      return DriverLoginScreen();
    } else {
      return UserLoginScreen();
    }
  }


  void _signin(BuildContext context){
    //add the thing
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  SignInScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Are you a Driver or a User?'),
              SizedBox(width: 20),
              DropdownButton(
                value: _isDriver ? 'Driver' : 'User',
                onChanged: (value) {
                  setState(() {
                    _isDriver = value == 'Driver';
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'User',
                    child: Text('User'),
                  ),
                  DropdownMenuItem(
                    value: 'Driver',
                    child: Text('Driver'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildLoginSection(),
          ElevatedButton(
              child: Text('Sign Up'),
              onPressed:() {_signin(context);},
            ),
        ],
      ),
      
    );
  }
}
