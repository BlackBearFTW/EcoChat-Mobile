import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:meta/meta.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'dart:convert';

abstract class SignalR {
  String serverUrl = "https://i496018core.venus.fhict.nl/";

  @protected
  HubConnection? _hubConnection;

  SignalR(String hubName) {
    _hubConnection =
        HubConnectionBuilder().withUrl(serverUrl + hubName).build();
    _hubConnection?.onclose(({Exception? error}) => print(error));
  }

  void initializeConnection() async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      print("Already connected");
      return;
    }

    await _hubConnection?.start();
  }

  void terminateConnection() => _hubConnection?.stop();

  HubConnection? _getConnection() => _hubConnection;

  HubConnectionState? getStatus() => _hubConnection?.state;
}

class SignalRMarkers extends SignalR {
  SignalRMarkers() : super("ecochat");

  //TODO make this work again...
  // final markerGuid = "f67e3947-8399-47a5-be34-74b0de6e3a5e"; // TEMP Guid id,
  // Future<MarkerModel> getOneMarker(String markerGuid) async {
  //   HubConnection _hubConnection = _getConnection();
  //   MarkerModel marker;
  //   _hubConnection.invoke("getOneMarker", args: [markerGuid]);
  //   await _hubConnection.on("receiveMarker", (List<Object> args) => marker = args as MarkerModel);
  //   return marker;
  // }

  //function gets data, when data received, runs function
  void getOneMarker(
      String markerGuid, void Function(MarkerModel? arguments) callBack) async {
    HubConnection? _hubConnection = _getConnection();
    await _hubConnection?.invoke("GetOneMarker", args: [markerGuid]);
    _hubConnection?.on(
      "receiveOneMarker",
      (List<dynamic>? args) => {
        callBack(
          MarkerModel.fromJson(args?.first),
        ),
      },
    );
  }

  void getAllMarkers(void Function(List<MarkerModel>? arguments) callBack) async {

    HubConnection? _hubConnection = _getConnection();
    await _hubConnection?.invoke("GetAllMarkers");
    List<MarkerModel> markers = [];
    _hubConnection?.on("receiveAllMarkers",(List<dynamic>? args) => {
        args?.first.forEach(
          (item) => markers.add(MarkerModel.fromJson(item)),
        ),
        callBack(markers),
        markers.clear(),
      },
    );
  }

// void getAllMarkers(
//     void Function(List<MarkerModel>? arguments) callBack) async {
//   var map2 = [];
//   HubConnection? _hubConnection = _getConnection();
//   await _hubConnection?.invoke("GetAllMarkers");
//
//   // _hubConnection?.on("receiveAllMarkers",(List<dynamic>? args) => print(args),
//   _hubConnection?.on(
//     "receiveAllMarkers",
//     (List<dynamic>? args) => {
//       args?.asMap().map(
//         (key, value) {
//           value.forEach((args) => map2[args?.id] = args?.id);
//           print(map2);
//           return map2;
//         },
//       ),
//       // callBack(
//       // args?.map((e) => MarkerModel?.fromJson(e)).toList(),
//       // ),
//     },
//   );
// }

// getPrintReceiveAllMarkers() => _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));

// getPrintReceiveAllMarkers() {
//   // final args = await _hubConnection.on("receiveAllMarkers", (List<Object> args));
//   _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));
// }

// getPrintReceiveAllMarkers() async => await _hubConnection.on("receiveAllMarkers", (List<Object> args) => print("Id that was loaded: $args"));

// void getAllMarkers() async {
//   HubConnection _hubConnection = _getConnection();
//   List<MarkerModel> markers;
//   _hubConnection.invoke("getAllMarkers");
//   await _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));
//   // return markers;
// }
}
