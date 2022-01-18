import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/services/authentication_api.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:flutter/services.dart';

class CreateFormView extends StatefulWidget {
  const CreateFormView({Key? key}) : super(key: key);

  @override
  _CreateFormViewState createState() => _CreateFormViewState();
}

var customPurple = const Color(0xff2980b9);

class _CreateFormViewState extends State<CreateFormView> {
  late AuthenticationApi authenticationApi;
  late SignalRMarkers signalRMarkers;
  late MarkersApi markersAPI;

  late bool _roofed;
  late String _name = "";
  late double _latitude;
  late double _longitude;
  late int _totalSlots;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildingRoofedField(String Roofed) {
    String dropdownValue = 'Niet Bedekt';

    //TODO fix unselected tap validation
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 1,
        color: Colors.black38,
      ),
      onChanged: (String? newValue) {
        setState(
              () {
            dropdownValue = newValue!;
            //convert to true or false
            if (dropdownValue == "Bedekt") {
              _roofed = true;
            } else {
              _roofed = false;
            }
          },
        );
      },
      items: <String>['Bedekt', 'Niet Bedekt'].map<DropdownMenuItem<String>>(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  Widget _buildingNameField(String Name) {
    return TextFormField(
      decoration: InputDecoration(labelText: "naam"),
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een naam in.";
        }
      },
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildingLatitudeField(String Latitude) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Latitude"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een Latitude in.";
        }
      },
      onSaved: (value) {
        _latitude = double.parse(value!);
        // _latitude = value! as double;
      },
    );
  }

  Widget _buildingLongitudeField(String Longitude) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Longitude"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer een Longitude in.";
        }
      },
      onSaved: (value) {
        _longitude = double.parse(value!);
      },
    );
  }

  Widget _buildingTotalSlotsField(String TotalSlots) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Poorten"),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Voer de aantal oplaat poorten in";
        }
      },
      onSaved: (value) {
        _totalSlots = int.parse(value!);
        // _totalSlots = value! as int;
      },
    );
  }

  Widget _buildingFormElevatedButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: customPurple,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(text),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        _formKey.currentState!.save();
        //dummy data
        int _batteryLevel = 89;
        int _availableSlots = _totalSlots;

        markersAPI.createMarker(
          MarkerModel("05b87fb9-5699-4ada-9718-ae44e9aa3706", _name, _roofed, _latitude, _longitude, _batteryLevel,
              _availableSlots, _totalSlots),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SignalRMarkers signalRMarkers = SignalRMarkers();
    authenticate();
  }

  void authenticate() async {
    authenticationApi = AuthenticationApi();
    String token = await authenticationApi.login("Vincent", "Vincent");
    markersAPI = MarkersApi(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildingRoofedField(""),
                    _buildingNameField(""),
                    _buildingLatitudeField(""),
                    _buildingLongitudeField(""),
                    _buildingTotalSlotsField(""),
                    SizedBox(height: 100),
                    _buildingFormElevatedButton("Toevoegen"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
