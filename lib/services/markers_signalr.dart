import 'dart:async';

import 'package:ecochat_app/abstracts/signal_r.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:ecochat_app/models/marker_model.dart';

class SignalRMarkers extends SignalR {
  SignalRMarkers() : super("markers");

  Stream<MarkerModel?> getOneMarkerStream(String markerGuid){
    final streamController = StreamController<MarkerModel?>();
    final _hubConnection = getConnection();
    _hubConnection?.invoke("GetOneMarker", args: [markerGuid]);

    _hubConnection?.on("ReceiveOneMarker", (List<dynamic>? args) => streamController.add(MarkerModel.fromJson(args?.first)));
    return streamController.stream;
  }


    Stream<List<MarkerModel>?> getAllMarkersStream(String markerGuid){
      final streamController = StreamController<List<MarkerModel>?>();
      final _hubConnection = getConnection();

      _hubConnection?.invoke("GetOneMarker", args: [markerGuid]);
      List<MarkerModel> markers = [];

      _hubConnection?.on("ReceiveOneMarker", (List<dynamic>? args) {
        args?.first.forEach((item) => markers.add(MarkerModel.fromJson(item)));
        streamController.add(markers);
        markers.clear();
      });

      return streamController.stream;
    }
}