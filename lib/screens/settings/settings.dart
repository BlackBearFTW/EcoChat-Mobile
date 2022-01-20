import 'package:ecochat_app/screens/authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _batteryWarningValue = 0;

  @override
  void initState() {
    super.initState();
    getBatteryWarningLevel().then((value) {
      setState(() => _batteryWarningValue = value);
    });
  }

  Future<int> getBatteryWarningLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("batteryWarningLevel") ?? 0;
  }

  void setBatteryWarningLevel(int newBatteryLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("batteryWarningLevel", newBatteryLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instellingen", style: TextStyle(fontWeight: FontWeight.bold)),
        titleSpacing: 0,
        backgroundColor: const Color(0xff7672FF),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [const Text("Batterij melding"), Text("$_batteryWarningValue%")],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Slider(
                  value: _batteryWarningValue.toDouble(),
                  onChanged: (newValue) {
                    setBatteryWarningLevel(newValue.toInt());
                    setState(() => _batteryWarningValue = newValue.toInt());
                  },
                  divisions: 100,
                  min: 0,
                  max: 100,
                ),
                Row(
                  children: const [
                    Text("0% (geen melding)"),
                    Text("100%")
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: Color(0xffd9d9d9),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child:TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthenticationView()),
                  );
                },
                child: Text('Login'),
              ),

            ),
          ),
          const Divider(
            thickness: 1,
            color: Color(0xffd9d9d9),
          ),
        ],
      ),
    );
  }
}