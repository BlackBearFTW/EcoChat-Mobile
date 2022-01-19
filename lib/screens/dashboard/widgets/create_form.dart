import 'package:ecochat_app/global_widgets/marker_popup_button.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:flutter/services.dart';

class CreateFormView extends StatefulWidget {
  String jsonWebToken;

  CreateFormView(this.jsonWebToken, {Key? key}) : super(key: key);

  @override
  _CreateFormViewState createState() => _CreateFormViewState();
}

class _CreateFormViewState extends State<CreateFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late MarkersApi markersAPI;
  final marker = MarkerModel.empty();

  @override
  void initState() {
    super.initState();
    markersAPI = MarkersApi(widget.jsonWebToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                    MarkerPopupButton(
                        label: "Aanmaken",
                        backgroundColor:
                        const Color(0xFF8CC63F),
                        labelColor: Colors.white,
                        onPress: () {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();

                      marker.availableSlots = marker.totalSlots;

                      markersAPI.createMarker(marker);
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
