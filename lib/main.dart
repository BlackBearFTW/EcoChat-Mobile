import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:ecochat_app/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'models/marker_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  Workmanager().initialize(callbackDispatcher);
  
  Workmanager().registerPeriodicTask(
      "4bh3uerdfhjrn4rjeudhn4rejhujrn3aksjhfiewhfjiwjfeg",
      "Battery Warning Check",
      initialDelay: Duration(minutes: 15));

  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    AndroidBatteryInfo? batteryInfo = await BatteryInfoPlugin().androidBatteryInfo;
    int _minBatteryLevel = await getBatteryWarningLevel();

    if (batteryInfo == null) return Future.value(false);

    int _batteryLevel = batteryInfo.batteryLevel!;

    if (_batteryLevel > _minBatteryLevel) return Future.value(true);
    if ([ChargingStatus.Full, ChargingStatus.Charging].contains(batteryInfo.chargingStatus)) return Future.value(true);

    final List<MarkerModel>? markers = await MarkersApi(null).getAllMarkers();
    Position location = await Geolocator.getCurrentPosition();

    if (markers == null) return Future.value(false);

    int? _distance = markers.fold(null, (int? total, MarkerModel current) {
      if (current.batteryLevel == 0) return total;
      int currentValue = current
          .distanceFrom(LatLng(location.latitude, location.longitude))
          .round();
      if (total == null) return currentValue;
      return currentValue < total ? currentValue : total;
    });

    if (_distance != null && _distance > 600) return Future.value(true);

    NotificationService().showNotifications("Lage batterij!",
        "Je batterij is nog maar $_batteryLevel%, ga snel naar het dichtstbijzijnde EcoChat bankje hier ongeveer $_distance meter vandaan.");

    return Future.value(true);
  });
}

Future<int> getBatteryWarningLevel() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("batteryWarningLevel") ?? 0;
}
