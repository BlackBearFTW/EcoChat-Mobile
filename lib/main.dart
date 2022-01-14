import 'package:battery_plus/battery_plus.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/battery_service.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/homepage/homepage.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final NotificationService _notificationService = NotificationService();
    final _signalRMarkers = SignalRMarkers();
    final BatteryService _batteryService = BatteryService();
    int _minBatteryLevel = await getBatteryWarningLevel();
    await _signalRMarkers.initializeConnection();

    Position location = await Geolocator.getCurrentPosition();
    //int batteryLevel = await _batteryService.batteryLevel;

    print("BatteryLevel");
    //print(batteryLevel);

    await _notificationService.showNotifications("BatteryLevel $_minBatteryLevel", location.toString());
    return Future.value(true);
  });
}

Future<int> getBatteryWarningLevel() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("batteryWarningLevel") ?? 0;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  Workmanager().registerOneOffTask(
      "4bh3uerdfhjrn4rjeudhn4rejhujrn3aksjhfiewhfjiwjfeg",
      "Test",
      initialDelay: const Duration(minutes:  1)
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  final BatteryService _batteryService = BatteryService();
  final NotificationService _notificationService = NotificationService();
  final _signalRMarkers = SignalRMarkers();
  late final stream = _signalRMarkers.getAllMarkersStream();
  late List<MarkerModel>? markers = [];
  late BatteryState _batteryState = BatteryState.unknown;
  int _minBatteryLevel = 0;

 @override
  void initState() {
   super.initState();

   SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);

   _signalRMarkers.initializeConnection().then((value) {
     stream.listen((data) => markers = data);
   });

   // getBatteryWarningLevel().then((value) {
   //   setState(() => _minBatteryLevel = value);
   // });

    _askForLocationPermission();

   // _batteryService.onBatteryStateChanged.listen((state) => _batteryState = state);
   //
   // _batteryService.onBatteryLevelChanged.listen((int batteryLevel) => _handleBatteryChanges(batteryLevel));
  }

  @override
  Widget build(BuildContext context) => const HomeView();

 void _handleBatteryChanges(int batteryLevel) async {
   if (batteryLevel <= _minBatteryLevel || _batteryState == BatteryState.charging) return;

   Position location = await Geolocator.getCurrentPosition();

   // Gets the distance of the marker that is the closest to user
   int? _distance = markers?.fold(null, (int? total, MarkerModel? current) {
     int currentValue = current!.distanceFrom(LatLng(location.latitude, location.longitude)).round();
     if (total == null) return currentValue;
     return currentValue < total ? currentValue : total;
   });

   if (_distance != null && _distance > 600) return;

   _notificationService.showNotifications(
       "Lage batterij!",
       "Je batterij is nog maar $_minBatteryLevel%, ga snel naar het dichtstbijzijnde EcoChat bankje ${_distance != null ? ", hier ongeveer $_distance meter vandaan." : "." }"
   );
 }

  void _askForLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    if (await Geolocator.checkPermission() != LocationPermission.denied) return;

    await Geolocator.requestPermission();
  }
}
