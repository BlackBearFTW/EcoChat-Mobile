// import 'package:ecochat_app/services/api_methods.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:flutter_guid/flutter_guid.dart';

// import 'package:singalr_flutter/hub_connection.dart';
// import 'package:singalr_flutter/hub_connection_builder.dart';

// import 'create_marker.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final serverUrl = "https://i496018core.venus.fhict.nl/ecochat";
  HubConnection hubConnection;
  double width = 100.0, height = 100.0;

  // NewMarker
  // final markerGuid = "813bd01a-e092-437b-bbe2-b60f980818fe"; // Guid id,
  final markerGuid = "f67e3947-8399-47a5-be34-74b0de6e3a5e"; // Guid id,
  // final markerGuid = Guid; // Guid id,
  final markerBool = true; // bool roofed,
  final markerAvailableSlots = 5; // int availableSlots,
  final markerTotalSlots = 5; // int totalSlots,
  final markerBattery = 100; // int Battery,
  final markerlatitude = 50.500; // string latitude,
  final markerlongitude = 50.000; // string longitude,


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSignalR();
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
              onPressed: () async {
                print("werkt");
                print(hubConnection.state);
                if (hubConnection.state == HubConnectionState.Connected) {
                  await hubConnection.invoke("getOneMarker", args: [markerGuid]);
                }
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
                print(hubConnection.state);
                if (hubConnection.state == HubConnectionState.Connected) {
                  await hubConnection.invoke("getAllMarkers");
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(hubConnection.state);
          hubConnection.state == HubConnectionState.Disconnected
              ? await hubConnection.start()
              : await hubConnection.stop();
          print(hubConnection.state);
        },
      ),
    );
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection.onclose((error) {
      print(error);
    });

    hubConnection.on("receiveOneMarker", _handleReceiveOneMarker);
    hubConnection.on("receiveAllMarkers", _handleReceiveAllMarkers);
  }


  _handleReceiveOneMarker(List<Object> args) {
    print("test2");
    print(args);
  }

  _handleReceiveAllMarkers(List<Object> args) {
    print("test3");
    print(args);
  }
}
