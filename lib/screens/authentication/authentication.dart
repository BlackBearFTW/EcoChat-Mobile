import 'package:ecochat_app/screens/homepage/homepage.dart';
import 'package:ecochat_app/services/authentication_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthenticationApi authenticationApi = AuthenticationApi();
  bool bToken = false;
  bool clicked = false;

  Future<String?> authenticate(_name, _password) async {

    String? token = await authenticationApi.login(_name.text, _password.text);
    if (token != null) {
      bToken = true;
    }

    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoChat", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff7672FF),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xff7672FF),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bToken
                  ? Container()
                  : clicked
                      ? const Text(
                          "Uw gebruikers naam of wachtwoord is incorrect.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          // overflow: TextOverflow.ellipsis,
                        )
                      : Container(),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _nameField,
                  decoration: const InputDecoration(
                    hintText: "Naam",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Naam",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordField,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Wachtwoord",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Wachtwoord",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: MaterialButton(
                  onPressed: () async {
                    authenticate(_nameField, _passwordField);
                    clicked = true;
                    setState(() {});
                    if (bToken) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(),
                        ),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
            ],
          )),
    );
  }
}
