import 'dart:async';
import 'dart:typed_data';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/screens/dashboard/widgets/create_form.dart';
import 'package:ecochat_app/screens/dashboard/widgets/marker_popup.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/utils/image_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:signalr_netcore/hub_connection.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool locationAllowed = false;
  bool activeSignalRConnection = false;

  // TODO: FETCH FROM LOGIN SCREEN
  final String TEST_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IlZpbmNlbnQiLCJyb2xlIjoiNGRNMW5mcjBtM2MwQ2g0VCIsIm5iZiI6MTY0MjYyNDc1NywiZXhwIjoxNjQyNjI4MzU3LCJpYXQiOjE2NDI2MjQ3NTd9.0HjNy86NRgfibvpvvEXMWnDvgkbN7N6h28X3lbbgwnU";
  final Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor grayMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  SignalRMarkers signalRMarkers = SignalRMarkers();
  late final stream = signalRMarkers.getAllMarkersStream();
  PersistentBottomSheetController? bottomSheetController;
  double _fabBottomPadding = 0;

  @override
  void initState() {
    super.initState();

    _loadCustomMarkerIcon();

    Geolocator.checkPermission().then((value) {
      setState(() => locationAllowed = [LocationPermission.always, LocationPermission.whileInUse].contains(value));
    });

    signalRMarkers.initializeConnection().then((value) {
      setState(() => activeSignalRConnection = signalRMarkers.getStatus() == HubConnectionState.Connected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Admin Dashboard",style: TextStyle(fontWeight: FontWeight.bold)),
          titleSpacing: 0,
        backgroundColor: const Color(0xff7672FF),
      ),
      body: activeSignalRConnection
          ? StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MarkerModel>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                  return const Center(child: Text("Loading Map...."));
                }

                Set<Marker> _markers = snapshot.data!
                    .map((data) => _createMarker(
                        data.id, LatLng(data.latitude, data.longitude),
                        grayedOut: data.batteryLevel < 15))
                    .toSet();

                return GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(51, 5), zoom: 8.4746),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(8, 18),
                  myLocationEnabled: true,
                  compassEnabled: false,
                  tiltGesturesEnabled: false,
                  onMapCreated: _onGoogleMapLoad,
                  markers: _markers,
                  mapToolbarEnabled: false,
                  onTap: (_) => _closeBottomSheet(),
                );
              })
          : const Center(child: Text("Loading Map...")),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: _fabBottomPadding),
            child: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.black),
              backgroundColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateFormView(TEST_TOKEN)),
              ),
            )));
  }

  void _loadCustomMarkerIcon() async {
    final Uint8List byteData = await ImageUtil.getBytesFromAsset("assets/marker-icon.png", 150);
    final Uint8List byteDataGray = await ImageUtil.getBytesFromAsset("assets/marker-icon-gray.png", 150);
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(byteData);
      grayMarkerIcon = BitmapDescriptor.fromBytes(byteDataGray);
    });
  }

  Marker _createMarker(String id, LatLng coordinates,
          {bool grayedOut = false}) =>
      Marker(
        markerId: MarkerId(id),
        position: coordinates,
        icon: grayedOut ? grayMarkerIcon : markerIcon,
        onTap: () => _showMarkerBottomSheet(id),
      );

  void _onGoogleMapLoad(GoogleMapController controller) async {
    _mapController.complete(controller);

    String _mapStyle = await rootBundle.loadString('assets/map_style.txt');
    controller.setMapStyle(_mapStyle);

    if (!locationAllowed) return;
    Position locationData = await Geolocator.getCurrentPosition();
    controller.moveCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude, locationData.longitude), 18));
  }

  void _closeBottomSheet() async {
    if (bottomSheetController == null) return;
    bottomSheetController!.close();
  }

  void _showMarkerBottomSheet(String _markerId) async {
    bottomSheetController = _scaffoldKey.currentState?.showBottomSheet((BuildContext context) {
      return MarkerPopup(
        signalRMarkersInstance: signalRMarkers,
        markerId: _markerId,
        jsonWebToken: TEST_TOKEN,
        closeMarkerPopup: _closeBottomSheet,
      );
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ));

    // This animates the FAB above the bottom sheet
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _fabBottomPadding = 80.0);

    await bottomSheetController!.closed;
    signalRMarkers.leaveGroup(_markerId);
    bottomSheetController = null;

    // This animates the FAB to its original location
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _fabBottomPadding = 0.0);
  }
}
