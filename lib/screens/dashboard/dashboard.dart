// import 'package:ecochat_app/services/api_methods.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:ecochat_app/services/signal_r.dart';

// import 'package:singalr_flutter/hub_connection.dart';
// import 'package:singalr_flutter/hub_connection_builder.dart';

// import 'create_marker.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SignalRMarkers signalRMarkers = SignalRMarkers();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(signalRMarkers.getStatus());
    signalRMarkers.getAllMarkers();
    // print(signalRMarkers.getStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(25),
            child: Text(
                "test",
              style: const TextStyle(fontSize: 20, color: Colors.green,),
                // signalRMarkers.getAllMarkers().toString(),
              // signalRMarkers.getStatus().toString(),
              // style: signalRMarkers.getStatus() == HubConnectionState.Disconnected
              //         ? const TextStyle(fontSize: 20, color: Colors.red,)
              //         : const TextStyle(fontSize: 20, color: Colors.green,),
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
                child: const Text(
                  'get all markers',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {}),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
