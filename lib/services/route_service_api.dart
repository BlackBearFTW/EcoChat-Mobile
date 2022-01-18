import 'dart:convert';
import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteServiceAPI {

  final String _apiKey = "5b3ce3597851110001cf6248b22ea2ab2dac408aab2870c02246d972";

  Future<Map<String, dynamic>?> _getData(LatLng destination) async {
    String baseUrl = "https://api.openrouteservice.org/v2/directions/foot-walking?";
    Position location = await Geolocator.getCurrentPosition();

    http.Response response = await http.get(Uri.parse(
        baseUrl + "api_key=$_apiKey&start=${location.longitude},${location.latitude}&end=${destination.longitude},${destination.latitude}"
    ));

    if (response.statusCode != 200) return null;

    return jsonDecode(response.body);
  }

  Future<int?> getTravelTime(LatLng destination) async {
    Map<String, dynamic>? data = await _getData(destination);
    if (data == null) return null;
    return (data['features'][0]['properties']['summary']['duration'] / 60).toInt();
  }

  Future<Set<Polyline>?> getRoute(LatLng destination) async {
    Map<String, dynamic>? data = await _getData(destination);
    if (data == null) return null;

    List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];
    List<LatLng> points = coordinates.map((point) => LatLng(point[1], point[0])).toList();

    Polyline polyLine = Polyline(
      polylineId: const PolylineId("PolyLineId"),
      points: points,
      color: const Color(0xFF8CC63F),
      width: 5,
    );

    return {polyLine};
  }
}