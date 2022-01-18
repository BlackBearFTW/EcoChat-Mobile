import 'dart:async';
import 'dart:typed_data';
import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/screens/homepage/widgets/mylocation_button.dart';
import 'package:ecochat_app/screens/homepage/widgets/marker_popup.dart';
import 'package:ecochat_app/services/markers_signalr.dart';
import 'package:ecochat_app/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:signalr_netcore/hub_connection.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool locationPermissionAllowed = false;
  bool activeSignalRConnection = false;

  final Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor grayMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  SignalRMarkers signalRMarkers = SignalRMarkers();
  late final stream = signalRMarkers.getAllMarkersStream();
  Set<Polyline> _polyLines = {};
  PersistentBottomSheetController? bottomSheetController;

  double _fabBottomPadding = 0;

  @override
  void initState() {
    super.initState();

    _loadCustomMarkerIcon();

    _askForLocationPermission().then((value) {
      setState(() => locationPermissionAllowed = value);
    });

    signalRMarkers.initializeConnection().then((value) {
      setState(() => activeSignalRConnection =
          signalRMarkers.getStatus() == HubConnectionState.Connected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("EcoChat",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff7672FF),
      ),
      body: activeSignalRConnection
          ? StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MarkerModel>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
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
                  polylines: _polyLines,
                  mapToolbarEnabled: false,
                  onTap: (_) => _onMapPress(),
                );
              })
          : const Center(child: Text("Loading Map...")),
      floatingActionButton: FutureBuilder<GoogleMapController>(
          future: _mapController.future,
          builder: (BuildContext context,
              AsyncSnapshot<GoogleMapController> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) return Container();

            return Padding(
              padding: EdgeInsets.only(bottom: _fabBottomPadding),
              child: MyLocationButton(
                disabled: locationPermissionAllowed,
                googleMapController: snapshot.data!,
              ),
            );
          }),
    );
  }

  void _loadCustomMarkerIcon() async {
    final Uint8List byteData =
        await ImageUtils.getBytesFromAsset("assets/marker-icon.png", 150);
    final Uint8List byteDataGray =
        await ImageUtils.getBytesFromAsset("assets/marker-icon-gray.png", 150);
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

    if (!locationPermissionAllowed) return;
    Position locationData = await Geolocator.getCurrentPosition();
    controller.moveCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude, locationData.longitude), 18));
  }

  void _onMapPress() async {
    if (bottomSheetController == null) return;
    bottomSheetController!.close();
  }

  Future<bool> _askForLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) return true;
    if (permission == LocationPermission.deniedForever) return false;

    LocationPermission status = await Geolocator.requestPermission();
    return [LocationPermission.always, LocationPermission.whileInUse]
        .contains(status);
  }

  void _showMarkerBottomSheet(String _markerId) async {
    bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet((BuildContext context) {
      return MarkerPopup(
        signalRMarkersInstance: signalRMarkers,
        markerId: _markerId,
        polyLineSetter: (Set<Polyline> polyLines) =>
            setState(() => _polyLines = polyLines),
        polyLines: _polyLines,
      );
    },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
