import 'dart:async';
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class MarkerPopup extends StatefulWidget {
  final SignalRMarkers signalRMarkersInstance;
  final String markerId;
  final Function(Set<Polyline> points) polyLineSetter;
  final Set<Polyline> polyLines;

  const MarkerPopup({
    Key? key,
    required this.signalRMarkersInstance,
    required this.markerId,
    required this.polyLineSetter,
    required this.polyLines
  }) : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  final String _apiKey = "5b3ce3597851110001cf6248b22ea2ab2dac408aab2870c02246d972";
  late final Stream<int?>? travelTimeStream;
  late LocationSettings locationSettings;
  bool locationAllowed = false;
  late Set<Polyline> _polyLines = widget.polyLines;

  late final Stream<MarkerModel?> markerStream = widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId).map((markerData) {
    if (markerData != null && locationAllowed) {
      travelTimeStream = Geolocator
          .getPositionStream(locationSettings: locationSettings)
          .asyncMap((event) async => await _getTravelTime(LatLng(markerData.latitude, markerData.longitude)));
    }

    return markerData;
   });
  
  @override
  void initState() {
    super.initState();

    Geolocator.checkPermission()
        .then((value) => setState(() => locationAllowed = [LocationPermission.always, LocationPermission.whileInUse].contains(value)));

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        intervalDuration: const Duration(seconds: 30),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

    }
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: markerStream,
        builder: (BuildContext context, AsyncSnapshot<MarkerModel?> snapshot) {

          if (!snapshot.hasData || snapshot.hasError) {
            return Wrap(children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: _displayLoader(),
              )
            ]);
          }

          MarkerModel? marker = snapshot.data!;

          return Wrap(
            children: [Container(
              margin: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(marker.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Accu percentage"),
                          Text("${marker.batteryLevel}%")
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Vrije USB"),
                          Text("${marker.availableSlots}/${marker.totalSlots}"),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Overdekt"),
                          Text(marker.roofed ? "Ja" : "Nee"),
                        ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Reistijd"),
                        if (!locationAllowed) const Text("-")
                        else StreamBuilder(
                            stream: travelTimeStream,
                            builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                              if (snapshot.hasError) print(snapshot.error);

                              if (snapshot.hasError) return const Text("Error");
                              if (!snapshot.hasData) return const Text("-");
                              return Text("${snapshot.data} min");
                            }),
                      ]),
                  const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        child: Text(
                          _polyLines.isEmpty ? "Bekijk Route" : "Stop Route",
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(!locationAllowed) return _showLocationAlertDialog();

                          if (_polyLines.isEmpty) {
                            final _tempSet = await getRouteFromAPI(LatLng(marker.latitude, marker.longitude));

                            if (_tempSet == null) return;
                            setState(() => _polyLines = _tempSet);
                            widget.polyLineSetter(_tempSet);
                          } else {
                            setState(() => _polyLines = {});
                            widget.polyLineSetter({});
                          }
                        },
                        fillColor: Color(locationAllowed ? (_polyLines.isEmpty ? 0xFF8CC63F : 0xFFC63F3F) : 0xFFA6A6A6),
                      ),
                    )
                  ]),
            )
            ],
          );
        });
  }

  Future<Map<String, dynamic>?> _getData(LatLng destination) async {
    String baseUrl = "https://api.openrouteservice.org/v2/directions/foot-walking?";
    Position location = await Geolocator.getCurrentPosition();

    Response response = await http.get(Uri.parse(
        baseUrl + "api_key=$_apiKey&start=${location.longitude},${location.latitude}&end=${destination.longitude},${destination.latitude}"
    ));

    if (response.statusCode != 200) return null;

    return jsonDecode(response.body);
  }

  Future<int?> _getTravelTime(LatLng destination) async {
    Map<String, dynamic>? data = await _getData(destination);
    if (data == null) return null;
    return (data['features'][0]['properties']['summary']['duration'] / 60).toInt();
  }

  Future<Set<Polyline>?> getRouteFromAPI(LatLng destination) async {
    Map<String, dynamic>? data = await _getData(destination);
    if (data == null) return null;

    List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];

    List<LatLng> points =
        coordinates.map((point) => LatLng(point[1], point[0])).toList();

    Polyline polyLine = Polyline(
      polylineId: const PolylineId("PolyLineId"),
      points: points,
      color: const Color(0xFF8CC63F),
      width: 5,
    );

    return {polyLine};
  }

  Widget _displayLoader() {
    int _informationColumns = 4;

    return SkeletonLoader(
      builder: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 256,
              alignment: Alignment.center,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 12 * _informationColumns.toDouble(),
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
                elevation: 0,
                child: const Text(
                  "Bekijk Route",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
                fillColor: const Color(0xFF8CC63F),
              ),
            )
          ]),
    );
  }

  void _showLocationAlertDialog() {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: const Text("Locatie geweigerd"),
        content: const Text("Sorry, deze functionaliteit is niet beschikbaar zonder je locatie aan te zetten 😓."),
        actions: [
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text(
              "Instellingen",
              style: TextStyle(color: Color(0xff7672FF)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Oké",
              style: TextStyle(color: Color(0xff7672FF)),
            ),
          )
        ]
    ));
  }
}
