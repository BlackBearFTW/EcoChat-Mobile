import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecochat_app/models/marker_model.dart';

class AuthenticationApi {
  String serverUrlAuth = "https://i496018core.venus.fhict.nl/api/authentication";

  Future<String> login(String username, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response = await http.post(
      Uri.parse(serverUrlAuth + "/login"),
      headers: {'authorization': basicAuth},
    );
    return response.body.toString();
  }
}