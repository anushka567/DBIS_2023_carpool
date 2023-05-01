import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DriverSignInScreen extends StatefulWidget {
  @override
  _DriverSignInScreenState createState() => _DriverSignInScreenState();
}

class _DriverSignInScreenState extends State<DriverSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _submit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // perform login logic for driver
    

    try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _username,
    password: _password,
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
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
            Text('Driver SignIn', style: TextStyle(fontSize: 20)),
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
              child: Text('Sign In'),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class UserSignInScreen extends StatefulWidget {
  const UserSignInScreen({super.key});

  @override
  State<UserSignInScreen> createState() => _UserSignInScreenState();
}

class _UserSignInScreenState extends State<UserSignInScreen> {

   final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  void _submit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // perform login logic for driver
       try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _username,
    password: _password,
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
     ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
    print('The account already exists for that email.');
  }
  else{
     ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.code)),
        );
    print(e);
  }
} catch (e) {
  print(e);
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
            Text('User SignIn', style: TextStyle(fontSize: 20)),
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
              
              child: Text('Sign in'),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}