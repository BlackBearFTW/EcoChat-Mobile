import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:meta/meta.dart';
import 'package:ecochat_app/models/marker_model.dart';
import 'dart:convert';

abstract class SignalR {
  String serverUrl = "https://i496018core.venus.fhict.nl/hub/";

  @protected
  HubConnection? _hubConnection;

  SignalR(String hubName) {
    _hubConnection =
        HubConnectionBuilder().withUrl(serverUrl + hubName).build();
    _hubConnection?.onclose(({Exception? error}) => print(error));
  }

  void initializeConnection() async {
    if (_hubConnection?.state == HubConnectionState.Connected) return print("Already connected");

    await _hubConnection?.start();
  }

  void terminateConnection() => _hubConnection?.stop();

  HubConnection? _getConnection() => _hubConnection;

  HubConnectionState? getStatus() => _hubConnection?.state;
}

class SignalRMarkers extends SignalR {
  SignalRMarkers() : super("markers");

  void getOneMarker(String markerGuid, void Function(MarkerModel? arguments) callBack) async {
    HubConnection? _hubConnection = _getConnection();
    await _hubConnection?.invoke("GetOneMarker", args: [markerGuid]);
    _hubConnection?.on("receiveOneMarker", (List<dynamic>? args) => callBack(MarkerModel.fromJson(args?.first)));
  }

  void getAllMarkers(void Function(List<MarkerModel>? arguments) callBack) async {
    HubConnection? _hubConnection = _getConnection();
    await _hubConnection?.invoke("GetAllMarkers");
    List<MarkerModel> markers = [];
    _hubConnection?.on("receiveAllMarkers", (List<dynamic>? args) => {
      args?.first.forEach((item) => markers.add(MarkerModel.fromJson(item))),
      callBack(markers),
      markers.clear(),
    });
  }
}