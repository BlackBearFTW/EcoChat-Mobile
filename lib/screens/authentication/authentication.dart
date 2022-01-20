import 'package:ecochat_app/global_widgets/marker_popup_button.dart';
import 'package:ecochat_app/screens/dashboard/dashboard.dart';
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
  late bool _passwordVisible;
  String username = "";
  String password = "";
  String? token = "";

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text("Inloggen",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff7672FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  cursorColor: const Color(0xff7672FF),
                  decoration: const InputDecoration(
                    labelText: "Gebruikersnaam",
                    labelStyle: TextStyle(color: Color(0xFFA6A6A6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA6A6A6)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA6A6A6)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) return null;
                    return "Voer een gebruikersnaam in.";
                  },
                  onSaved: (String? value) => username = value!
              ),
              TextFormField(
                  cursorColor: const Color(0xff7672FF),
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Wachtwoord",
                    labelStyle: const TextStyle(color: Color(0xFFA6A6A6)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA6A6A6)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA6A6A6)),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xff7672FF)
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value!.isNotEmpty) return null;
                    return "Voer een wachtwoord in.";
                  },
                  onSaved: (String? value) => password = value!
              ),
              const SizedBox(height: 16),
              MarkerPopupButton(
                  label: "Inloggen",
                  backgroundColor: const Color(0xFF8CC63F),
                  labelColor: Colors.white,
                  onPress: () async {
                    if (!formKey.currentState!.validate()) return;
                    formKey.currentState!.save();

                    print("Gebruikersnaam: $username, Wachtwoord: $password");

                    token = await authenticationApi.login(username.trim(), password.trim());

                    if (token == null) {
                      _showIncorrectInputAlertDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardView(jsonWebToken: token!)),
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIncorrectInputAlertDialog() {
    showDialog(context: context, builder: (BuildContext context) =>
        AlertDialog(
            title: const Text("Ongeldige login"),
            content: const Text("De ingevoerde gebruikersnaam/wachtwoord combinatie is onjuist."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Oké", style: TextStyle(color: Color(0xFF8CC63F))),
              )
            ]
        ));
  }
}
