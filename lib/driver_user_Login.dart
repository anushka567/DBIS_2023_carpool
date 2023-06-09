import 'package:cabshare/UserDashboard.dart';
import 'package:cabshare/DriverDashboard.dart';
import 'package:flutter/material.dart';

class DriverLoginScreen extends StatefulWidget {
  @override
  _DriverLoginScreenState createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // perform login logic for driver
      
      if(_username == 'Myname' && _password == "1234"){
           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverDashboardPage()),
    );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Driver Login', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onSaved: (value) {
                _username = value!;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {

   final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _submit(context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if(_username == 'Myname' && _password == "1234"){
           Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDashboardPage()),
    );
      }
      // perform login logic for driver
    }
  }

 @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Login', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onSaved: (value) {
                _username = value!;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              
              child: Text('Login'),
              onPressed:() {_submit(context);},
            ),
          ],
        ),
      ),
    );
  }
}