import 'dart:async';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/authentication_api.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/route_service_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class MarkerPopup extends StatefulWidget {
  final SignalRMarkers signalRMarkersInstance;
  final String markerId;
  final Function() closeMarkerPopup;

  const MarkerPopup(
      {Key? key,
      required this.signalRMarkersInstance,
      required this.markerId,
      required this.closeMarkerPopup,
      })
      : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  final String _apiKey = "5b3ce3597851110001cf6248b22ea2ab2dac408aab2870c02246d972";
  late final Stream<int?>? travelTimeStream;
  late LocationSettings locationSettings;
  bool locationAllowed = false;
  bool editingMarker = false;
  final routeServiceApi = RouteServiceAPI();
  late AuthenticationApi authenticationApi;
  late MarkersApi markersApi;

  void authenticate() async {
    authenticationApi = AuthenticationApi();
    String token = await authenticationApi.login("Vincent", "Vincent");
    markersApi = MarkersApi(token);
  }

  late final Stream<MarkerModel?> markerStream = widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId).map((markerData) {
    if (markerData != null && locationAllowed) {
      travelTimeStream = Geolocator
          .getPositionStream(locationSettings: locationSettings)
          .asyncMap((event) async => await routeServiceApi.getTravelTime(LatLng(markerData.latitude, markerData.longitude)));
    }

    return markerData;
  });

  @override
  void initState() {
    super.initState();
    authenticate();

    Geolocator.checkPermission().then((value) {
      setState(() => locationAllowed = [LocationPermission.always, LocationPermission.whileInUse].contains(value));
    });

    locationSettings = getLocationSettings();
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
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    marker.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff7672FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text("Update"),
                      onPressed: () {
                        if (editingMarker == false) {
                          editingMarker = true;
                        } else if (editingMarker == true) {
                          editingMarker = false;
                        }
                        print(editingMarker);
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff7672FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text("Delete"),
                      onPressed: () {
                        markersApi.deleteMarker(marker.id);
                        widget.closeMarkerPopup();
                      },
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _customRow("Accu percentage", "${marker.batteryLevel}%"),
                  _customRow("Vrije USB", marker.availableSlots.toString()),
                  _customRow("Overdekt", marker.roofed ? "Ja" : "Nee"),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _updateForm(
                            marker.id,
                            marker.roofed,
                            marker.name,
                            marker.latitude.toString(),
                            marker.longitude.toString(),
                            marker.batteryLevel.toString(),
                            marker.availableSlots.toString(),
                            marker.totalSlots.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ],
          );
        });
  }

  LocationSettings getLocationSettings() {

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        intervalDuration: const Duration(seconds: 30),
      );
    }

    if ([TargetPlatform.iOS,  TargetPlatform.macOS].contains(defaultTargetPlatform)) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
        pauseLocationUpdatesAutomatically: true,
      );
    }

      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
  }

  Widget _displayLoader() {
    int _informationColumns = 4;

    return SkeletonLoader(
      builder: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
      ]),
    );
  }

  void _showLocationAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Locatie geweigerd"),
        content: const Text("Sorry, deze functionaliteit is niet beschikbaar zonder je locatie aan te zetten 😓."),
        actions: [
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text("Instellingen",
              style: TextStyle(color: Color(0xff7672FF)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Oké",
              style: TextStyle(color: Color(0xff7672FF)),
            ),
          )
        ],
      ),
    );
  }


//form widgets
  Widget _updateForm(id, roofed, name, latitude, longitude, batteryLevel, availableSlots, totalSlots) {
    if (editingMarker == true) {
      return Column(
        children: [
          _buildingRoofedField(roofed),
          _buildingNameField(name),
          _buildingLatitudeField(latitude),
          _buildingLongitudeField(longitude),
          _buildingTotalSlotsField(totalSlots),
          SizedBox(height: 30),
          _buildingFormElevatedButton("Toevoegen", id),
        ],
      );
    }
    return Container();
  }


  Widget _customRow(String textContent, String textData) {
    if (editingMarker == false){
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(textContent), Text(textData)]);
    }
    return Container();
  }


  late bool _roofed;
  late String _name = "";
  late double _latitude;
  late double _longitude;
  late int _totalSlots;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildingRoofedField(Roofed) {
    String dropdownValue;
    Roofed ? dropdownValue = 'Niet Bedekt' : dropdownValue = 'Bedekt';

    //TODO fix unselected tap validation
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 1,
        color: Colors.black38,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          //convert to true or false
          if (dropdownValue == "Bedekt") {
            _roofed = true;
          } else {
            _roofed = false;
          }
        },
        );
      },
      items: <String>['Bedekt', 'Niet Bedekt'].map<DropdownMenuItem<String>>(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  Widget _buildingNameField(String Name) {
    return TextFormField(
      decoration: InputDecoration(labelText: "naam"),
      initialValue: Name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een naam in.";
        }
      },
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildingLatitudeField(String Latitude) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Latitude"),
      keyboardType: TextInputType.number,
      initialValue: Latitude,
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een Latitude in.";
        }
      },
      onSaved: (value) {
        _latitude = double.parse(value!);
        // _latitude = value! as double;
      },
    );
  }

  Widget _buildingLongitudeField(String Longitude) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Longitude"),
      keyboardType: TextInputType.number,
      initialValue: Longitude,
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een Longitude in.";
        }
      },
      onSaved: (value) {
        _longitude = double.parse(value!);
      },
    );
  }

  Widget _buildingTotalSlotsField(String TotalSlots) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Poorten"),
      keyboardType: TextInputType.number,
      initialValue: TotalSlots,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer de aantal oplaat poorten in";
        }
      },
      onSaved: (value) {
        _totalSlots = int.parse(value!);
        // _totalSlots = value! as int;
      },
    );
  }

  Widget _buildingFormElevatedButton(String text, id) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff7672FF),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(text),
      onPressed: () {
        if (!formKey.currentState!.validate()) {
          return;
        }
        formKey.currentState!.save();
        //dummy data
        int _batteryLevel = 89;
        int _availableSlots = _totalSlots;

        print(MarkerModel(id, _name, _roofed, _latitude, _longitude, _batteryLevel, _availableSlots, _totalSlots));
        markersApi.updateMarker(id,
          MarkerModel(id, _name, _roofed, _latitude, _longitude, _batteryLevel, _availableSlots, _totalSlots),
        );
      },
    );
  }
}