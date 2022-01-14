import 'package:flutter/cupertino.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';

abstract class SignalR {
  String serverUrl = "https://i496018core.venus.fhict.nl/hub/";

  HubConnection? _hubConnection;

  SignalR(String hubName) {
    _hubConnection = HubConnectionBuilder().withUrl(serverUrl + hubName).build();
    _hubConnection?.onclose(({Exception? error}) => print(error));
  }


  Future<void> initializeConnection() async {
    if (_hubConnection?.state == HubConnectionState.Connected) return print("Already connected");

   return await _hubConnection?.start();
  }

  void terminateConnection() => _hubConnection?.stop();

  @protected
  HubConnection? getConnection() => _hubConnection;

  HubConnectionState? getStatus() => _hubConnection?.state;
}