import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';

import 'package:http/http.dart';

 class MarkersApi {
  String serverUrl = "https://i496018core.venus.fhict.nl/api/Markers/";
  String token = "";

  MarkersApi(this.token);

  getMarker(data) async {

    var response = await http.get(
      Uri.parse(serverUrl),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  createMarker(data) async {



    var response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        "Content-Type": "application/json",
        'authorization': 'Bearer $token'
      },
      body: json.encode(data),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  updateMarker(putData, guid) async {


    var response = await http.put(
      Uri.parse(serverUrl + guid),
      headers: {
        "Content-Type": "application/json",
        'authorization': 'Bearer $token'
      },
      body: json.encode(putData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  deleteMarker(guid) async {


    var response = await http.delete(
      Uri.parse(serverUrl + guid),
      headers: {
        "Content-Type": "application/json",
        'authorization': 'Bearer $token'
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
