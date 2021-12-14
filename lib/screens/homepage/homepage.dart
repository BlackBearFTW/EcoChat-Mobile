import 'dart:typed_data';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/screens/homepage/widgets/marker_popup.dart';
import 'package:ecochat_app/screens/homepage/widgets/mylocation_button.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:signalr_netcore/hub_connection.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Location _locationHandler = Location();
  bool locationPermissionAllowed = false;
  bool activeSignalRConnection = false;

  GoogleMapController? _mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  SignalRMarkers signalRMarkers = SignalRMarkers();
  late final stream = signalRMarkers.getAllMarkersStream();

  @override
  void initState() {
    super.initState();

    _loadCustomMarkerIcon();

    _askForLocationPermission().then((value) {
      setState(() => locationPermissionAllowed = value);
    });

    signalRMarkers.initializeConnection().then((value) {
      activeSignalRConnection = signalRMarkers.getStatus() == HubConnectionState.Connected;
      setState(() {});
    });
  }

  void _loadCustomMarkerIcon() async {
    final Uint8List byteData = await ImageUtils.getBytesFromAsset(
        "assets/marker-icon.png", 150);
    setState(() => markerIcon = BitmapDescriptor.fromBytes(byteData));
  }

  Marker _createMarker(String id, LatLng coordinates) =>
      Marker(
        markerId: MarkerId(id),
        position: coordinates,
        icon: markerIcon,
        onTap: () => _showMarkerBottomSheet(id),
      );

  void _onGoogleMapLoad(GoogleMapController controller) async {
    _mapController = controller;

    // TODO: FIX THIS, CAUSES INFINITE REDRAWING
    // setState(() => _mapController = controller);
    String _mapStyle = await rootBundle.loadString('assets/map_style.txt');
    _mapController?.setMapStyle(_mapStyle);

    if (!locationPermissionAllowed) return;
    LocationData locationData = await _locationHandler.getLocation();
    _mapController?.moveCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude!, locationData.longitude!), 18));
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
        title: const Text("ECOCHAT", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () => null, icon: const Icon(Icons.settings))],
        backgroundColor: const Color(0xff7672FF),
      ),
      body: activeSignalRConnection ? StreamBuilder(stream: stream, builder: (BuildContext context, AsyncSnapshot<List<MarkerModel>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) return Container();

        final Set<Marker> _markers = snapshot.data!.map((data) => _createMarker(data.id, LatLng(data.latitude, data.longitude))).toSet();


        return GoogleMap(
          initialCameraPosition: const CameraPosition(
              target: LatLng(51, 5), zoom: 8.4746),
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          minMaxZoomPreference: const MinMaxZoomPreference(8, 18),
          myLocationEnabled: true,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          onMapCreated: _onGoogleMapLoad,
          markers: _markers,
          mapToolbarEnabled: false,
        );
      }): const Center(child: Text("Loading....")),
      floatingActionButton: _mapController != null ? MyLocationButton(
        disabled: locationPermissionAllowed,
        googleMapController: _mapController!,
        locationHandler: _locationHandler,
      ) : null,
    );
  }

  void _showMarkerBottomSheet(String _markerId) {
    showModalBottomSheet(
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16)),
        ),
        context: context,
        builder: (BuildContext context) => MarkerPopup(markerId: _markerId, signalRMarkersInstance: signalRMarkers)
    );
  }
}

