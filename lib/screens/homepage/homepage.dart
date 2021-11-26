import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String _mapStyle;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    getLocation();

    rootBundle.loadString('/assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  void getLocation() async{
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8)
          ),
        ),
        title: const Text(
          "ECOCHAT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff33835c),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(50.94284, 5.921534),
          zoom: 14.4746,
        ),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        compassEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          controller.setMapStyle(_mapStyle);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showModalBottomSheet(
              barrierColor: Colors.white.withOpacity(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              context: context,
              builder: (BuildContext context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: const Center(
                        child: Text('This is a modal bottom sheet')),
                  ))
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// showModalBottomSheet(
//     barrierColor: Colors.white.withOpacity(0),
//     backgroundColor: Colors.red,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16)),
//     ),
//     context: context,
//     builder: (BuildContext context) => SizedBox(
//           height: MediaQuery.of(context).size.height * 0.25,
//           child: const Center(
//               child: Text('This is a modal bottom sheet')),
//         ))
