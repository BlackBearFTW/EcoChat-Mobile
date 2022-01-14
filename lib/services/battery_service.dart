import 'dart:async';

import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> get batteryLevel => _battery.batteryLevel;

  Stream<BatteryState> get onBatteryStateChanged => _battery.onBatteryStateChanged;

  Stream<int> get onBatteryLevelChanged {
    final streamController = StreamController<int>();
    streamController.add(100);

    Timer.periodic(const Duration(minutes: 1), (_) async => streamController.add(await _battery.batteryLevel));
    return streamController.stream;
  }
}