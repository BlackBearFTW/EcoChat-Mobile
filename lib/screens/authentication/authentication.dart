import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/api_methods.dart';

import '../homepage/homepage.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailField,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 35),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordField,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Password",
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
                    bool shouldNavigate =
                    await register(_emailField.text, _passwordField.text);
                    if (shouldNavigate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
                    }
                  },
                  child: const Text("Register"),
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
                    bool shouldNavigate =
                    await signIn(_emailField.text, _passwordField.text);
                    if (shouldNavigate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
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
