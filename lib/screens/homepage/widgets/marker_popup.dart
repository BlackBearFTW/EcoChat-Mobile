import 'dart:async';
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MarkerPopup extends StatefulWidget {
  final String markerId;
  final SignalRMarkers signalRMarkersInstance;
  final Function(Set<Polyline> points) polyLineSetter;
  final Set<Polyline> polyLineSet;

  const MarkerPopup({Key? key,
    required this.markerId,
    required this.signalRMarkersInstance,
    required this.polyLineSetter,
    required this.polyLineSet}) : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  final String _apiKey = "5b3ce3597851110001cf6248b22ea2ab2dac408aab2870c02246d972";
  late final stream = widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId);
  bool _locationAllowed = false;
  final Location _locationHandler = Location();
  Stream<LocationData>? locationDataStream;
  int? travelTimeInMinutes;

  @override
  void initState() {
    super.initState();

    _locationHandler.hasPermission().then((value) {
      setState(() => _locationAllowed = (value == PermissionStatus.granted));
    });

    _locationHandler.changeSettings(interval: 60000, distanceFilter: 20, accuracy: LocationAccuracy.high);
    locationDataStream = _locationHandler.onLocationChanged;
  }

  @override
  void dispose() {
    print("Disposing State");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print(widget.polyLineSet);

    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<MarkerModel?> snapshot) {
          MarkerModel? marker = snapshot.data;

          return Wrap(
            children: [Container(
              margin: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: snapshot.connectionState == ConnectionState.waiting || marker == null ? displayLoader()
                  : Column(
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
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: const [
                    //       Text("Reistijd"),
                    //       Text("Fix me"),
                    //     ]),
                    // StreamBuilder(
                    //     stream: locationDataStream,
                    //     builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
                    //       if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) return const Text("-");
                    //
                    //       return FutureBuilder<int?>(
                    //           future: getTravelTime(LatLng(marker.latitude, marker.longitude)),
                    //           builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
                    //             if (snapshot.hasError) {
                    //               print(snapshot.error);
                    //               return const Text("Error");
                    //             }
                    //             if (!snapshot.hasData) return const Text("-");
                    //
                    //             print("FutureBuilder: ${snapshot.data}");
                    //             return Text(snapshot.data.toString());
                    //           });
                    //
                    //     }
                    // ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8) ),
                        elevation: 0,
                        child: Text(
                          // FIXME Not updating text on click
                          // Explanation: https://discord.com/channels/420324994703163402/421445316617961502/921356141131358229
                          widget.polyLineSet.isEmpty ? "Bekijk Route" : "Stop Route",
                          style: TextStyle(color: _locationAllowed ? Colors.white : Colors.white60),
                        ),
                        onPressed:  () {
                          if (!_locationAllowed) return;

                          widget.polyLineSet.isEmpty ?
                            getRouteFromAPI(LatLng(marker.latitude, marker.longitude)) :
                              widget.polyLineSetter({});
                        },
                        fillColor: Color(!_locationAllowed ?  0xFFA6A6A6 : (widget.polyLineSet.isEmpty) ? 0xFF8CC63F : 0xFFc63f3f ),
                      ),
                    )
                  ]),
            )],
          );
        });
  }

  // TODO: Solve this in next sprint, gets data but doesn't update UI
  // Future<int?> getTravelTime(LatLng destination) async {
  //   String baseUrl = "https://api.openrouteservice.org/v2/directions/foot-walking?";
  //   LocationData location = await _locationHandler.getLocation();
  //
  //   Response response = await http.get(Uri.parse(
  //       baseUrl + "api_key=$_apiKey&start=${location.longitude},${location.latitude}&end=${destination.longitude},${destination.latitude}"
  //   ));
  //
  //   if (response.statusCode != 200) return null;
  //
  //   var data = await jsonDecode(response.body);
  //   return (data['features'][0]['properties']['summary']['duration'] / 60).toInt();
  // }

  void getRouteFromAPI(LatLng destination) async {
    String baseUrl = "https://api.openrouteservice.org/v2/directions/foot-walking?";
    LocationData location = await _locationHandler.getLocation();

    Response response = await http.get(Uri.parse(
        baseUrl + "api_key=$_apiKey&start=${location.longitude},${location.latitude}&end=${destination.longitude},${destination.latitude}"
    ));

    if (response.statusCode != 200) return;

    var data = jsonDecode(response.body);
    List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];

    List<LatLng> points = coordinates.map((point) => LatLng(point[1], point[0])).toList();

    Polyline polyLine = Polyline(
        polylineId: const PolylineId("PolyLineId"),
        points: points,
        color: const Color(0xFF8CC63F),
        width: 5,
    );
    
    widget.polyLineSetter({polyLine});
  }

  Widget displayLoader() {
    int _informationColumns = 3;

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
}
