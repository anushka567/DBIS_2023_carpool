import 'package:cabshare/Login.dart';
import 'package:flutter/material.dart';
import 'MapScreen.dart';
import 'LocationPicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  
  );

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  
  runApp(MyApp());
}



class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(title : 'My app',
    home: LoginScreen());
  }
}



