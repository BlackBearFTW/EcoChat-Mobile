import 'package:ecochat_app/models/marker_model.dart';
import 'package:flutter/material.dart';

class MarkerPopup extends StatefulWidget {
  const MarkerPopup({Key? key, required this.marker}) : super(key: key);

  final MarkerModel marker;

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Center(
        child: Row(children: [
            Column(children: [
              Row(children: [
                Text("${widget.marker.batteryLevel}%"),
                const Text("Accu percentage"),
              ]),
              Row(children: [
                Text("${widget.marker.availableSlots}/${widget.marker.totalSlots}"),
                const Text("Beschikbare USB poorten"),
              ]),
              if (widget.marker.roofed) Row(children: [
                Text("${widget.marker.roofed}%"),
                const Text("Overdekt"),
              ]),
            ]),
            ElevatedButton(onPressed: () => {}, child: const Text("Bekijk Route"))
          ]),
      ),
    );
  }
}
