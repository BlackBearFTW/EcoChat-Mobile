import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/screens/create_marker/create_marker.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/services/markers_api.dart';
import 'package:flutter/services.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

var customPurple = const Color(0xff2980b9);

class _DashboardViewState extends State<DashboardView> {
  late SignalRMarkers signalRMarkers;
  late MarkersAPI markersAPI;

  late bool _roofed;
  late String _name = "";
  late double _latitude;
  late double _longitude;
  late int _totalSlots;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildingRoofedField() {
    String dropdownValue = 'Niet Bedekt';

    //TODO fix unselected tap validation
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(height: 1,color: Colors.black38,),
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

  Widget _buildingNameField() {
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

  Widget _buildingLatitudeField() {
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

  Widget _buildingLongitudeField() {
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

  Widget _buildingTotalSlotsField() {
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
  Widget _buildingFormElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: customPurple,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text('Toevoegen'),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        _formKey.currentState!.save();

        print(_roofed);
        print(_name);
        print(_latitude);
        print(_longitude);
        print(_totalSlots);


        markersAPI.addMapDataToApi(_roofed, _name, _latitude, _longitude, _totalSlots);

      },
    );
  }

  @override
  void initState() {
    super.initState();
    signalRMarkers = SignalRMarkers();
    markersAPI = MarkersAPI();
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
                      _buildingRoofedField(),
                      _buildingNameField(),
                      _buildingLatitudeField(),
                      _buildingLongitudeField(),
                      _buildingTotalSlotsField(),
                      SizedBox(height: 100),
                      _buildingFormElevatedButton(),
                    ],
                  ),
                )),

// #region old stuff
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'get one markers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                signalRMarkers.getOneMarker(
                  "45dff001-8ff8-4228-9bac-e610bdd6e02e",
                  (MarkerModel? marker) => {
                    print(marker?.id),
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'get all markers',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                // signalRMarkers.getAllMarkers();
                signalRMarkers.getAllMarkers(
                  (List<MarkerModel>? markers) => {
                    print(markers?.elementAt(0).id),
                    print(markers?.elementAt(0).name),
                    print(markers?.elementAt(0).batteryLevel),
                    print(markers?.elementAt(0).roofed),
                    print(markers?.elementAt(0).latitude),
                    print(markers?.elementAt(0).longitude),
                    print(markers?.elementAt(0).availableSlots),
                    print(markers?.elementAt(0).totalSlots),
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'update data',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                markersAPI.updateData();
                // markersAPI.getToken("joost", "joost");
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'delete data',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () async {
                markersAPI.deleteData();
                // markersAPI.getToken("joost", "joost");
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: TextButton(
              child: const Text(
                'form',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const createMarker()),
                );
              },
            ),
          ),
          ],
        ),
      ),
//endregion
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          signalRMarkers.initializeConnection();
          print(signalRMarkers.getStatus());
        },
      ),
    );
  }
}
