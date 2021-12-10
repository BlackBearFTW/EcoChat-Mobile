import 'package:http/http.dart' as http;
import 'dart:convert';


class MarkersAPI {

  Future<String> getMarkers() async {
    try {
      var response = await http.get(Uri.parse("https://i496018core.venus.fhict.nl/api/Markers/"));
      var json = jsonDecode(response.body);
      var value = json['location'].toString();
      return value;
    } catch (e) {
      print(e.toString());
      return "NaN";
    }
  }

  Future<String> getMarker(String id) async {
    try {
      var response = await http.get(Uri.parse("https://i496018core.venus.fhict.nl/api/Markers/" + id));
      var json = jsonDecode(response.body);
      var value = json['location'].toString();
      return value;
    } catch (e) {
      print(e.toString());
      return "NaN";
    }
  }


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
