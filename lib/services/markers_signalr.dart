import 'package:ecochat_app/abstracts/signal_r.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:ecochat_app/models/marker_model.dart';

class SignalRMarkers extends SignalR {
  SignalRMarkers() : super("markers");

  void getOneMarker(String markerGuid, void Function(MarkerModel? arguments) callBack) async {
    HubConnection? _hubConnection = getConnection();
    await _hubConnection?.invoke("GetOneMarker", args: [markerGuid]);
    _hubConnection?.on("receiveOneMarker", (List<dynamic>? args) => callBack(MarkerModel.fromJson(args?.first)));
  }

  void getAllMarkers(void Function(List<MarkerModel>? arguments) callBack) async {
    HubConnection? _hubConnection = getConnection();
    await _hubConnection?.invoke("GetAllMarkers");
    List<MarkerModel> markers = [];
    _hubConnection?.on("receiveAllMarkers", (List<dynamic>? args) => {
      args?.first.forEach((item) => markers.add(MarkerModel.fromJson(item))),
      callBack(markers),
      markers.clear(),
    });
  }
}