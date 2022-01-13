import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:signalr_netcore/hub_connection.dart';

class createMarker extends StatefulWidget {
  const createMarker({Key? key}) : super(key: key);

  @override
  _createMarkerState createState() => _createMarkerState();
}

class _createMarkerState extends State<createMarker> {
  late SignalRMarkers signalRMarkers;
  late MarkersAPI markersAPI;
  final TextEditingController _controller = new TextEditingController();
  var items = ['Working a lot harder', 'Being a lot smarter', 'Being a self-starter', 'Placed in charge of trading charter'];
  bool activeSignalRConnection = false;

  @override
  void initState() {
    super.initState();
    signalRMarkers = SignalRMarkers();
    markersAPI = MarkersAPI();

    signalRMarkers.initializeConnection().then((value) {
      setState(() => activeSignalRConnection = signalRMarkers.getStatus() == HubConnectionState.Connected);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aanmaken marker'),
      ),
      body: Column(
        children: [
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
                    print("test"),
                    print(markers.toString()),
                    print(markers?.elementAt(0).id),
                    print(markers?.elementAt(0).name),
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

    // Map data = {
    // "roofed": true,
    // "name": "Jazz Bar",
    // "latitude": 45.451555623652524,
    // "longitude": 4.480393955095925,
    // "batteryLevel": 89,
    // "totalSlots": 5,
    // "openSlots": 1
    // };
          Container(
            margin: EdgeInsets.all(25),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.roofing),
                hintText: 'Zit er een dak op?',
                labelText: 'Bedakking',
              ),
              validator: (value) { // The validator receives the text that the user has entered.
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(controller: _controller)
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          _controller.text = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return items.map<PopupMenuItem<String>>((String value) {
                            return PopupMenuItem(child: Text(value), value: value);
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
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
