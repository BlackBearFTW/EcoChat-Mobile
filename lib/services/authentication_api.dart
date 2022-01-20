import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationApi {
  String serverUrlAuth = "https://i496018core.venus.fhict.nl/api/authentication";

  Future<String?> login(String username, String password) async {
    http.Response response = await http.post(
      Uri.parse(serverUrlAuth + "/login"),
      headers: {"authorization": "Basic ${base64Encode(utf8.encode('$username:$password'))}"},
    );

    if (response.statusCode != 200) return null;
    return response.body.toString();
  }
}