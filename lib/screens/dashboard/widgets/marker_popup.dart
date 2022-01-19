import 'dart:async';
import 'package:ecochat_app/global_widgets/marker_popup_button.dart';
import 'package:ecochat_app/global_widgets/marker_popup_row.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/route_service_api.dart';
import 'package:ecochat_app/utils/location_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class MarkerPopup extends StatefulWidget {
  final SignalRMarkers signalRMarkersInstance;
  final String markerId;
  final String jsonWebToken;
  final void Function() closeMarkerPopup;

  const MarkerPopup({Key? key,
      required this.signalRMarkersInstance,
      required this.markerId,
      required this.jsonWebToken,
      required this.closeMarkerPopup,
      }) : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  Stream<int?>? travelTimeStream;
  late LocationSettings locationSettings;
  bool locationAllowed = false;
  bool editingMarker = false;
  final routeServiceApi = RouteServiceAPI();
  late MarkersApi markersApi;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final Stream<MarkerModel?> markerStream = widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId).map((markerData) {
    if (travelTimeStream == null && markerData != null && locationAllowed) {
      travelTimeStream = Geolocator
          .getPositionStream(locationSettings: locationSettings)
          .asyncMap((event) async => await routeServiceApi.getTravelTime(LatLng(markerData.latitude, markerData.longitude)));
    }

    return markerData;
  });

  @override
  void initState() {
    super.initState();

    Geolocator.checkPermission().then((value) {
      setState(() => locationAllowed = [LocationPermission.always, LocationPermission.whileInUse].contains(value));
    });

    markersApi = MarkersApi(widget.jsonWebToken);
    locationSettings = LocationUtil.getSettings();
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
                child: editingMarker ? displayUpdateForm(marker) : displayInformationPopup(marker),
              ),
            ],
          );
        });
  }

  Widget displayInformationPopup(MarkerModel marker) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        marker.name,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 16),
      MarkerPopupRow("Accu percentage", "${marker.batteryLevel}%"),
      MarkerPopupRow("Vrije USB", "${marker.availableSlots}/${marker.totalSlots}"),
      MarkerPopupRow("Overdekt", marker.roofed ? "Ja" : "Nee"),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Reistijd"),
            if (!locationAllowed)
              const Text("-")
            else
              StreamBuilder(
                  stream: travelTimeStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<int?> snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    if (snapshot.hasError) return const Text("Error");
                    if (!snapshot.hasData) return const Text("-");
                    return Text("${snapshot.data} min");
                  }),
          ]),
      const SizedBox(height: 16),
      Row(
        children: [
          MarkerPopupButton(
              label: "Bewerken",
              backgroundColor: const Color(0xFF8CC63F),
              labelColor: Colors.white,
              onPress: () => setState(() => editingMarker = !editingMarker)
          ),
          const SizedBox(width: 8),
          MarkerPopupButton(
              label: "Verwijderen",
              backgroundColor: const Color(0xFFC63F3F),
              labelColor: Colors.white,
              onPress: () => _showDeleteAlertDialog(marker)
          ),
        ],
      )
    ]);
  }

  Widget displayUpdateForm(MarkerModel marker) {
    return Form(
      key: formKey,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildField("Naam", TextInputType.name, marker.name, (value) => marker.name = value!),
          buildField("Latitude", TextInputType.number, "${marker.latitude}", (value) => marker.latitude = double.parse(value!)),
          buildField("Longitude", TextInputType.number, "${marker.longitude}", (value) => marker.longitude = double.parse(value!)),
          buildField("Aantal poorten", TextInputType.number, "${marker.totalSlots}", (value) => marker.totalSlots = int.parse(value!)),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Overdekt"),
                  Switch(value: marker.roofed, onChanged: (x) => marker.roofed = x)
                ]
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              MarkerPopupButton(
                  label: "Annuleer",
                  backgroundColor: const Color(0xFFA6A6A6),
                  labelColor: Colors.white,
                  onPress: () => setState(() => editingMarker = !editingMarker)
              ),
              const SizedBox(width: 8),
              MarkerPopupButton(
                  label: "Opslaan",
                  backgroundColor: const Color(0xFF8CC63F),
                  labelColor: Colors.white,
                  onPress: () {
                    if (!formKey.currentState!.validate()) return;
                    formKey.currentState!.save();

                    marker.availableSlots = marker.totalSlots;

                    markersApi.updateMarker(marker.id, marker);

                    setState(() => editingMarker = !editingMarker);
                  }
              ),
            ],
          )
        ],
      ),
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

  void _showDeleteAlertDialog(MarkerModel marker) {
    showDialog(context: context, builder: (BuildContext context) =>
        AlertDialog(
            title: const Text("Verwijder marker"),
            content: const Text("Je staat op het punt om de geselecteerde marker te verwijderen, weet je het zeker?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annuleer", style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  markersApi.deleteMarker(marker.id);
                  widget.closeMarkerPopup();
                },
                child: const Text("Verwijder", style: TextStyle(color: Color(0xFFC63F3F))),
              )
            ]
        ));
  }

  Widget buildField(String label, TextInputType keyboardType, String initialValue, void Function(String? value) onSaved) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      initialValue: initialValue,
      validator: (value) {
        if (value!.isNotEmpty) return null;
        return "Voer een ${label.toLowerCase()} in.";
      },
      onSaved: onSaved
    );
  }
}