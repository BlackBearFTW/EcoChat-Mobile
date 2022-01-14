import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

String serverUrl = "https://i496018core.venus.fhict.nl/api/Markers/";

class MarkersAPI {
  Future<String> getOneMarkers(String id) async {
    try {
      var response = await http.get(Uri.parse(serverUrl + id));
      var json = jsonDecode(response.body);
      var value = json['id'].toString();
      return value;
    } catch (e) {
      print(e.toString());
      return "NaN";
    }
  }

  Future<String> getAllMarkers() async {
    try {
      var response = await http.get(Uri.parse(serverUrl));
      var json = jsonDecode(response.body);
      var value = json['id'].toString();
      return value;
    } catch (e) {
      print(e.toString());
      return "NaN";
    }
  }


  getAuthToken() async {
    try {
      var response = await http.get(Uri.parse(serverUrl));
      var json = jsonDecode(response.body);
      var value = json['id'].toString();
      return value;
    } catch (e) {
      print(e.toString());
      return "NaN";
    }

    token =

    print(token);
  }


  useAuthToken() async {
    String token = await getAuthToken();
    final response = http.get(Uri.parse(serverUrl), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });


  }

  //TODO AUTH required

  // https://docs.flutter.dev/cookbook/networking/authenticated-requests
  //post
  //put
  //delete

  Future<bool> signIn(String email, String password) async {
    //TODO send signIn to api

    try {
      // TODO send request to api
      return true;
    } catch (e) {
      //TODO return error to user
      // print(e.toString());
      return false;
    }
  }

//not clean enough/ smooth enough for publish - but will work for now
  Future<bool> register(String email, String password) async {
    //TODO send register to api

    try {
      //TODO call api
      return true;
    } catch (e) {
      //TODO return error to user
      // print(e.toString());
      return false;
    }
  }
}
