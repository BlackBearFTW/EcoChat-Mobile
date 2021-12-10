import 'package:ecochat_app/models/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/signal_r.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late SignalRMarkers signalRMarkers;

  @override
  void initState() {
    super.initState();
    signalRMarkers = SignalRMarkers();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'get one markers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                signalRMarkers.getOneMarker(
                  "813bd01a-e092-437b-bbe2-b60f980818fe",
                  (MarkerModel? marker) => {
                    print(marker?.id),
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'get all markers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                // signalRMarkers.getAllMarkers();
                signalRMarkers.getAllMarkers(
                  (List<MarkerModel>? markers) => {
                    print(markers?.elementAt(0).id),
                    print(markers?.elementAt(0).batteryLevel),
                    print(markers?.elementAt(0).roofed),
                    print(markers?.elementAt(0).latitude),
                    print(markers?.elementAt(0).longitude),
                    print(markers?.elementAt(0).availableSlots),
                    print(markers?.elementAt(0).totalSlots),
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: Row(
              children: [
                Text("test"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          signalRMarkers.initializeConnection();
          print(signalRMarkers.getStatus());
        },
      ),
    );
  }

}


