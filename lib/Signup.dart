import 'package:flutter/material.dart';
import 'driver_user_signin.dart';
import 'Login.dart';
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isDriver = false;

  Widget _buildLoginSection() {
    if (_isDriver) {
      return DriverSignInScreen();
    } else {
      return UserSignInScreen();
    }
  }


  void _login(BuildContext context){
    //add the thing
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
              child: Text('Account Already Exists? Login'),
              onPressed:(){ _login(context);},
            ),
        ],
      ),
      
    );
  }
}
