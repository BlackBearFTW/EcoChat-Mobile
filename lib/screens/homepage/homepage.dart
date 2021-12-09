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
  final Location _locationHandler = Location();
  bool locationPermissionAllowed = false;

  GoogleMapController? _mapController;
  late BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = {};


  @override
  void initState() {
    _loadCustomMarkerIcon();

    _askForLocationPermission().then((value) => setState(() => locationPermissionAllowed = value));
    super.initState();
  }

  void _loadCustomMarkerIcon() async {
    BitmapDescriptor _customMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        "assets/marker-icon.png"
    );

    setState(()  {
      markerIcon = _customMarker;
    });
  }

  Marker _createMarker(String id, LatLng coordinates) => Marker(
      markerId: MarkerId(id),
      position: coordinates,
      icon: markerIcon
  );

  void _onGoogleMapLoad(GoogleMapController controller) async {
    _mapController = controller;
    String _mapStyle = await rootBundle.loadString('assets/map_style.txt');
    _mapController?.setMapStyle(_mapStyle);

    setState(() {
      _markers.add(_createMarker("avgre-43er", const LatLng(51.451555623652524, 5.480393955095925)));
    });

    if (!locationPermissionAllowed) return;
    LocationData locationData = await _locationHandler.getLocation();
    _mapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(locationData.latitude!, locationData.longitude!), 18));
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
        backgroundColor: const Color(0xff7672FF),
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
        markers: _markers,
        mapToolbarEnabled: false,
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
