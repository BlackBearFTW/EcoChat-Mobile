import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:flutter/material.dart';

class MarkerPopup extends StatefulWidget {
  const MarkerPopup({Key? key, required this.markerId, required this.signalRMarkersInstance}) : super(key: key);

  final String markerId;
  final SignalRMarkers signalRMarkersInstance;

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  MarkerModel? marker;

  @override
  void initState() {

    widget.signalRMarkersInstance.getOneMarker(widget.markerId, (markerData) {
      marker = markerData;

      print(marker?.id);
      if (mounted) setState(() {});

    });

    super.initState();
    print('State init');
  }

  @override
  void dispose() {
    super.dispose();
    print('State dispose');
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Center(
        child: marker == null ?
        const Text("Loading...") :

        Row(children: [
          Column(children: [
            Row(children: [
              Text("${marker!.batteryLevel}%"),
              const Text("Accu percentage"),
            ]),
            Row(children: [
              Text("${marker!.availableSlots}/${marker!.totalSlots}"),
              const Text("Beschikbare USB poorten"),
            ]),
            if (marker!.roofed) Row(children: [
              Text("${marker!.roofed}%"),
              const Text("Overdekt"),
            ]),
          ]),
          ElevatedButton(onPressed: () => {}, child: const Text("Bekijk Route"))
        ]),

      ),
    );
  }
}
