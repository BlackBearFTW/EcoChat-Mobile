import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:meta/meta.dart';
import 'package:ecochat_app/models/marker_model.dart';

abstract class SignalR {
  String serverUrl = "https://i496018core.venus.fhict.nl/";

  @protected
  HubConnection? _hubConnection;

  SignalR(String hubName) {
    _hubConnection = HubConnectionBuilder().withUrl(serverUrl + "ecochat").build();
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

  HubConnectionState? _getStatus() => _hubConnection?.state;
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

  Future<void> getAllMarkers() async {
    HubConnection? _hubConnection = _getConnection();
    await _hubConnection?.invoke("getAllMarkers");
  }

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
