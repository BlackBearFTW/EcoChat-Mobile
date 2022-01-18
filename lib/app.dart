import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'screens/homepage/homepage.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 @override
  void initState() {
   super.initState();

   SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);

    _askForLocationPermission();
  }

 @override
 Widget build(BuildContext context) {
   return const MaterialApp(
     home: HomeView(),
     debugShowCheckedModeBanner: false,
   );
 }

  void _askForLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    if (await Geolocator.checkPermission() != LocationPermission.denied) return;

    await Geolocator.requestPermission();
  }
}
