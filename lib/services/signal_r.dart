import 'package:flutter/cupertino.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:meta/meta.dart';
import 'package:ecochat_app/models/marker_model.dart';

abstract class SignalR {
  String serverUrl = "https://i496018core.venus.fhict.nl/";

  @protected
  HubConnection _hubConnection;

  SignalR(String hubName) {
    _hubConnection =
        HubConnectionBuilder().withUrl(serverUrl + hubName).build();
    _hubConnection.onclose((error) => print(error));
    startConnection();
  }

  startConnection() async {
    _hubConnection.state == HubConnectionState.Disconnected
        ? await _hubConnection.start()
        : await _hubConnection.stop();
    print(_hubConnection.state);
  }

  void initializeConnection() => _hubConnection.start();

  void terminateConnection() => _hubConnection.stop();

  HubConnection _getConnection() => _hubConnection;

  HubConnectionState _getStatus() => _hubConnection.state;
}

class SignalRMarkers extends SignalR {
  SignalRMarkers() : super("ecochat");

  final markerGuid = "f67e3947-8399-47a5-be34-74b0de6e3a5e"; // TEMP Guid id,
  Future<MarkerModel> getOneMarker(String markerGuid) async {
    HubConnection _hubConnection = _getConnection();
    MarkerModel marker;
    _hubConnection.invoke("getOneMarker", args: [markerGuid]);
    await _hubConnection.on("receiveMarker", (List<Object> args) => marker = args as MarkerModel);
    return marker;
  }

  Future<MarkerModel> getAllMarkers() {
    HubConnection _hubConnection = _getConnection();
    List<MarkerModel> markers;
    _hubConnection.invoke("getAllMarkers");
    // _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));
    // return markers;
    print("test3");
    // getPrintReceiveAllMarkers();
    print(getPrintReceiveAllMarkers());
    print("test4");
  }

  // getPrintReceiveAllMarkers() => _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));

  getPrintReceiveAllMarkers() {
    // final args = await _hubConnection.on("receiveAllMarkers", (List<Object> args));
    _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));
  }

// getPrintReceiveAllMarkers() async => await _hubConnection.on("receiveAllMarkers", (List<Object> args) => print("Id that was loaded: $args"));

// void getAllMarkers() async {
//   HubConnection _hubConnection = _getConnection();
//   List<MarkerModel> markers;
//   _hubConnection.invoke("getAllMarkers");
//   await _hubConnection.on("receiveAllMarkers", (List<Object> args) => print(args));
//   // return markers;
// }
}
