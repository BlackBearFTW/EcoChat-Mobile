import 'package:ecochat_app/abstracts/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';

class MarkersApi {
  String serverUrl = "https://i496018core.venus.fhict.nl/api/Markers/";
  late Map<String, String> headers;

  MarkersApi(String? token) {
    if (token == null) return;
    headers = {
      "Content-Type": "application/json",
      'authorization': 'Bearer $token'
    };
  }

  //Gets one maker
  Future<MarkerModel?> getMarker(String id) async {
    http.Response response = await http.get(
      Uri.parse(serverUrl + id),
    );
    if (response.statusCode != 200) return null;

    return MarkerModel.fromJson(jsonDecode(response.body));
  }

  //Gets all makers and puts them in a list
  Future<List<MarkerModel>?> getAllMarkers() async {
    http.Response response = await http.get(
      Uri.parse(serverUrl),
    );
    if (response.statusCode != 200) return null;

    List<MarkerModel> markers = [];
    jsonDecode(response.body).forEach((item) => markers.add(MarkerModel.fromJson(item)));
    return markers;
  }

  void createMarker(MarkerModel data) async {
    await http.post(
      Uri.parse(serverUrl),
      headers: headers,
      body: json.encode(data),
    );
  }

  void updateMarker(String guid, MarkerModel modifiedData) async {
    await http.put(
      Uri.parse(serverUrl + guid),
      headers: headers,
      body: json.encode(modifiedData),
    );
  }
}

  void deleteMarker(String guid) async {
    await http.delete(
      Uri.parse(serverUrl + guid),
      headers: headers,
    );

  }
}
