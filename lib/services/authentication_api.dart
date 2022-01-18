import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationApi {
  String serverUrlAuth = "https://i496018core.venus.fhict.nl/api/authentication";

  Future<String> login(String username, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response = await http.post(
      Uri.parse(serverUrlAuth + "/login"),
      headers: {'authorization': basicAuth},
    );

    if (response.statusCode == 401) {
      return "";
    }
    return response.body.toString();
  }
}