import 'dart:async';
import 'package:ecochat_app/global_widgets/marker_popup_button.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ecochat_app/types/PopupActionEnum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerEditorPopup extends StatefulWidget {
  final String jsonWebToken;
  final String? markerId;
  final FormAction action;
  final void Function(bool newValue) toggleEditMode;
  final void Function() closeMarkerPopup;
  final GoogleMapController controller;

  const MarkerEditorPopup({Key? key,
        this.markerId,
        required this.jsonWebToken,
        required this.action,
        required this.controller,
        required this.toggleEditMode,
        required this.closeMarkerPopup
      }) : super(key: key);

  @override
  _MarkerEditorPopupState createState() => _MarkerEditorPopupState();
}

class _MarkerEditorPopupState extends State<MarkerEditorPopup> {
  late MarkersApi markersApi;
  Future<MarkerModel?>? markerFuture;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    markersApi = MarkersApi(widget.jsonWebToken);
    if (widget.action == FormAction.UPDATE && widget.markerId == null) super.dispose();
    if (widget.action == FormAction.UPDATE) markerFuture = markersApi.getMarker(widget.markerId!);
    if (widget.action == FormAction.CREATE) markerFuture = _getMarkerFuture();
  }

  @override
  Widget build(BuildContext context) {
    if (markerFuture == null) return Container();

    return Wrap(
      children: [Container(
        margin: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: markerFuture,
          builder: (BuildContext context, AsyncSnapshot<MarkerModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) return Container();

            MarkerModel marker = snapshot.data!;

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildField("Naam", TextInputType.name, marker.name, false, (value) => marker.name = value!),
                  _buildField("Latitude", TextInputType.number, "${marker.latitude}", true, (value) => marker.latitude = double.parse(value!)),
                  _buildField("Longitude", TextInputType.number, "${marker.longitude}", true, (value) => marker.longitude = double.parse(value!)),
                  _buildField("Aantal poorten", TextInputType.number, "${marker.totalSlots}", false, (value) => marker.totalSlots = int.parse(value!)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Overdekt"),
                          Switch(value: marker.roofed, onChanged: (x) => marker.roofed = x),
                        ]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      MarkerPopupButton(
                        label: "Annuleer",
                        backgroundColor: const Color(0xFFA6A6A6),
                        labelColor: Colors.white,
                        onPress: () {
                          (widget.action == FormAction.UPDATE) ? widget.toggleEditMode(false) : widget.closeMarkerPopup();
                        },
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

                            if (widget.action == FormAction.UPDATE) {
                              markersApi.updateMarker(marker.id, marker);
                              widget.toggleEditMode(false);
                            }
                            if (widget.action == FormAction.CREATE) {
                              markersApi.createMarker(marker);
                              widget.closeMarkerPopup();
                            }

                            widget.closeMarkerPopup();
                          }),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      )],
    );
  }


  Future<MarkerModel> _getMarkerFuture() async {
    MarkerModel marker = MarkerModel.empty();
    LatLng center = await getCenter();

    marker.longitude = center.longitude;
    marker.latitude = center.latitude;
    return marker;
  }

  Future<LatLng> getCenter() async {
    LatLngBounds visibleRegion = await widget.controller.getVisibleRegion();
    return LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
    );
  }

  Widget _buildField(String label, TextInputType keyboardType, String initialValue, bool clearButton, void Function(String? value) onSaved) {
    TextEditingController _controller = TextEditingController(text: initialValue);

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: !clearButton ? null :  IconButton(onPressed: _controller.clear, icon: const Icon(Icons.clear)),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) return "Voer een ${label.toLowerCase()} in.";
      },
      onSaved: onSaved,
    );
  }
}