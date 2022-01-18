import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  late String id;
  late String name;
  late bool roofed;
  late double latitude;
  late double longitude;
  late int batteryLevel;
  late int availableSlots;
  late int totalSlots;

  MarkerModel(this.id, this.name, this.roofed, this.latitude, this.longitude, this.batteryLevel, this.availableSlots, this.totalSlots);

  MarkerModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      roofed = json['roofed'];
      latitude = json['latitude'];
      longitude = json['longitude'];
      batteryLevel = json['batteryLevel'];
      availableSlots = json['availableSlots'];
      totalSlots = json['totalSlots'];
    } catch (error) {
      print(error);
    }
  }

  double distanceFrom(LatLng otherCoordinates) => Geolocator.distanceBetween(latitude, longitude, otherCoordinates.latitude, otherCoordinates.longitude);

}

