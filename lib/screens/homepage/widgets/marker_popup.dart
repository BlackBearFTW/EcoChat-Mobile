import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flutter/material.dart';

class MarkerPopup extends StatefulWidget {
  final String markerId;
  final SignalRMarkers signalRMarkersInstance;

  const MarkerPopup(
      {Key? key, required this.markerId, required this.signalRMarkersInstance})
      : super(key: key);

  @override
  _MarkerPopupState createState() => _MarkerPopupState();
}

class _MarkerPopupState extends State<MarkerPopup> {
  late final stream =
      widget.signalRMarkersInstance.getOneMarkerStream(widget.markerId);

  @override
  Widget build(BuildContext context) {
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Reistijd"),
                          Text("12 min"),
                        ]),
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
            )],
          );
        });
  }

  Widget displayLoader() {
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
}
