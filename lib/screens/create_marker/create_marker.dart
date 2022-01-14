// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ecochat_app/models/marker_model.dart';
// import 'package:ecochat_app/services/markers_signalr.dart';
// import 'package:ecochat_app/services/markers_api.dart';
// import 'package:signalr_netcore/hub_connection.dart';
//
// class createMarker extends StatefulWidget {
//   const createMarker({Key? key}) : super(key: key);
//
//   @override
//   _createMarkerState createState() => _createMarkerState();
// }
//
// class _createMarkerState extends State<createMarker> {
//   late SignalRMarkers signalRMarkers;
//   late MarkersApi markersAPI;
//   final TextEditingController _controller = new TextEditingController();
//   var items = ['Working a lot harder', 'Being a lot smarter', 'Being a self-starter', 'Placed in charge of trading charter'];
//   bool activeSignalRConnection = false;
//
//   @override
//   void initState() {
//     super.initState();
//     signalRMarkers = SignalRMarkers();
//     markersAPI = MarkersApi();
//
//     signalRMarkers.initializeConnection().then((value) {
//       setState(() => activeSignalRConnection = signalRMarkers.getStatus() == HubConnectionState.Connected);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('aanmaken marker'),
//       ),
//       body: Te
//       ),
//     );
//   }
// }
