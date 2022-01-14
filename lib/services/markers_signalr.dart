import 'dart:async';
import 'package:ecochat_app/abstracts/signal_r.dart';
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


    Stream<List<MarkerModel>?> getAllMarkersStream(){
      final streamController = StreamController<List<MarkerModel>?>();
      final _hubConnection = getConnection();

      _hubConnection?.invoke("GetAllMarkers");

      _hubConnection?.on("ReceiveAllMarkers", (List<dynamic>? args) {
        List<MarkerModel> _markers = [];

        args?.first.forEach((item) => _markers.add(MarkerModel.fromJson(item)));
        streamController.add(_markers);
      });

      return streamController.stream;
    }

    void leaveGroup(String markerGuid) {
      final _hubConnection = getConnection();
      _hubConnection?.invoke("RemoveFromGroup", args: [markerGuid]);
    }
}