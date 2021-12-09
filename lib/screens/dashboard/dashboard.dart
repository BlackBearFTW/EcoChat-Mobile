// import 'package:ecochat_app/services/api_methods.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/signal_r.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

// import 'create_marker.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late SignalRMarkers signalRMarkers;

  final serverUrl = "https://i496018core.venus.fhict.nl/";
  HubConnection? _hubConnection;
  double width = 100.0, height = 100.0;
  final markerGuid = "f67e3947-8399-47a5-be34-74b0de6e3a5e"; // Guid id,

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(signalRMarkers.getStatus());

    signalRMarkers = SignalRMarkers();
    // signalRMarkers.initializeConnection();
    // _hubConnection?.start();

    // signalRMarkers.getAllMarkers();

    // print(signalRMarkers.getStatus());
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
                    print(markers?.elementAt(0).batteryLevel),

                  },
                );
              },
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

  // void initSignalR() {
  //   _hubConnection = HubConnectionBuilder().withUrl(serverUrl + "ecochat").build();
  //   _hubConnection?.onclose(({Exception? error}) => print(error));
  //   _hubConnection?.on("receiveAllMarkers", (List<Object>? args) => print(args));
  // }

  handleReceiveOneMarker(List<Object> args) {
    print("test2");
    print(args);
  }

  handleReceiveAllMarkers(List<Object> args) {
    print("test3");
    print(args);
  }
}

