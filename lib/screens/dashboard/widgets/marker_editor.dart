import 'package:ecochat_app/global_widgets/marker_popup_button.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkerEditor extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MarkerModel marker;
  final void Function(MarkerModel marker) onSave;
  final void Function() onCancel;

  MarkerEditor({Key? key, required this.marker, required this.onSave, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
                onPress: () => onCancel(),
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

                    onSave(marker);
                  }
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildField(String label, TextInputType keyboardType, String initialValue, void Function(String? value) onSaved) {
    return TextFormField(
      cursorColor: const Color(0xff7672FF),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFA6A6A6)),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFA6A6A6)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFA6A6A6)),
          ),
        ),
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
