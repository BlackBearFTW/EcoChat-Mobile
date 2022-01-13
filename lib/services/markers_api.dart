import 'package:ecochat_app/abstracts/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


class MarkersAPI extends Api {
  MarkersAPI() : super("markers");


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

  addMapDataToApi(_roofed, _name, _latitude, _longitude, _totalSlots) {
    Map data = {
      "roofed": _roofed,
      "name": _name,
      "latitude": _latitude,
      "longitude": _longitude,
      "batteryLevel": 89,
      "totalSlots": _totalSlots,
      "openSlots": 1
    };

    createMarkerApi(data);
  }

  updateData() {
    const guid = "45dff001-8ff8-4228-9bac-e610bdd6e02e";
    Map putData = {
      "id": "45dff001-8ff8-4228-9bac-e610bdd6e02e",
      "roofed": true,
      "name": "Jazz Bar aangepast",
      "latitude": 51.447891844987100,
      "longitude": 5.475144377687420,
      "batteryLevel": 69,
      "totalSlots": 5,
      "openSlots": 1
    };

    updateMarkerApi(putData, guid);
  }

  deleteData() {
    const guid = "93e3cfe2-798b-48f3-bc8a-72f0547e2525";


    deleteMarkerApi(guid);
  }
}

// Future<Candidate> candidateAuth({Map map}) async {
//   String url = 'http://10.0.2.2:3000/v1/api/auth/candidate';
//   await http
//       .post(url,
//       headers: {
//         'Content-type': 'application/json',
//         'Accept': 'application/json'
//       },
//       body: jsonEncode(map))
//       .then((response) {
//     if (response.statusCode == 201) {
//       token = Candidate.fromJson(json.decode(response.body)).token;
//       Candidate().setToken(token);
//       return Candidate.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed auth');
//     }
//   });
// }

getAuthToken() async {}

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
