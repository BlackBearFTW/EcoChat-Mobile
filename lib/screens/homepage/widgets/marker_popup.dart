import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:flutter/material.dart';

class MarkerPopup extends StatefulWidget {
  final String markerId;
  final SignalRMarkers signalRMarkersInstance;

  const MarkerPopup({Key? key, required this.markerId, required this.signalRMarkersInstance}) : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {

  late final stream = widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: stream, builder: (BuildContext context, AsyncSnapshot<MarkerModel?> snapshot) {
      MarkerModel? marker = snapshot.data;

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: snapshot.connectionState == ConnectionState.waiting || marker == null ?
            const Text("Loading...") :
            Column(children: [

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                Column(children: [
                  Text("${marker.batteryLevel}%"),
                  const Text("Accu percentage"),
                ]),

                Column(children: [
                  Text("${marker.availableSlots}/${marker.totalSlots}"),
                  const Text("Beschikbare USB poorten"),
                ]),

                if (marker.roofed) Column(children: const [
                  Icon(Icons.roofing),
                  Text("Overdekt"),
                ]),

              ]),

              SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                    child: const Text("Bekijk Route",
                      style:  TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                    fillColor: const Color(0xFF8CC63F),
                ),
              )
            ]),

          ),
        ),
      );
    });
  }
}