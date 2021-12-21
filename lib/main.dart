import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'screens/homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EcoChat',
      home: GlobalApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GlobalApp extends StatefulWidget {
  const GlobalApp({Key? key}) : super(key: key);

  @override
  _GlobalAppState createState() => _GlobalAppState();
}

class _GlobalAppState extends State<GlobalApp> {
 @override
  void initState() {

   SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);

    _askForLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }

  void _askForLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    if (await Geolocator.checkPermission() != LocationPermission.denied) return;

    await Geolocator.requestPermission();
  }
}

