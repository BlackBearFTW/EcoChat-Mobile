import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _batteryWarningValue = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instellingen", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  onChanged: (newValue) => setState(() => _batteryWarningValue = newValue.toInt()),
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
        ],
      ),
    );
  }
}