import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Stream<int> get onBatteryLevelChange {
    final streamController = StreamController<int>();
    streamController.add(100);

    Timer.periodic(const Duration(seconds: 30), (_) async => streamController.add(await _battery.batteryLevel));
    return streamController.stream;
  }
}