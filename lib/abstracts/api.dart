import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';

import 'package:http/http.dart';

abstract class Api {
  String serverUrl = "https://i496018core.venus.fhict.nl/api/Markers/";
  String serverUrlAuth = "https://i496018core.venus.fhict.nl/api/authentication/login";

  Api(String hubName) {}

  // getToken(String username, String password) async {
  getToken() async {
    String username = 'Vincent';
    String password = 'Vincent';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var response = await http.post(
      Uri.parse(serverUrlAuth),
      headers: {'authorization': basicAuth},
    );
    return response.body.toString();
  }

  createMarkerApi(data) async {
    print("createMarkerApi");
    var token = await getToken();

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


  updateMarkerApi(putData, guid) async {
    print("updateMarkerApi");
    var token = await getToken();
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



  deleteMarkerApi(guid) async {
    print("deleteMarkerApi");
    var token = await getToken();

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
