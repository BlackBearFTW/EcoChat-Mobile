import 'package:ecochat_app/screens/homepage/widgets/mylocation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? _mapController;
  final Location _locationHandler = Location();
  bool locationPermissionAllowed = false;

  @override
  void initState() {
    _askForLocationPermission().then((value) => {
      setState(() => locationPermissionAllowed = value),
  });
    super.initState();
  }

  void _onGoogleMapLoad(GoogleMapController controller) async {
    _mapController = controller;
    String _mapStyle = await rootBundle.loadString('assets/map_style.txt');
    controller.setMapStyle(_mapStyle);
  }

  Future<bool> _askForLocationPermission() async {
    await _locationHandler.requestService();

    if (await _locationHandler.hasPermission() == PermissionStatus.granted) return true;
    if (await _locationHandler.hasPermission() == PermissionStatus.deniedForever) return false;

    PermissionStatus status = await _locationHandler.requestPermission();
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ECOCHAT", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff33835c),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(51, 5), zoom: 14.4746),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        minMaxZoomPreference: const MinMaxZoomPreference(8, 18),
        myLocationEnabled: true,
        compassEnabled: false,
        tiltGesturesEnabled: false,
        onMapCreated: _onGoogleMapLoad,
      ),
      floatingActionButton: _mapController != null ? MyLocationButton(
        disabled: locationPermissionAllowed,
        googleMapController: _mapController!,
        locationHandler: _locationHandler,
      ) : null,
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
