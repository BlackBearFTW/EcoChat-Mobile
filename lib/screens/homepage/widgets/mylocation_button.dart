import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocationButton extends StatelessWidget {
  final bool disabled;
  final GoogleMapController googleMapController;

  const MyLocationButton({Key? key, required this.disabled, required this.googleMapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: disabled ? _handleClick : null,
      backgroundColor: disabled ? Colors.white : Colors.grey,
      child: disabled ?
      const Icon(Icons.my_location, color: Colors.black) :
      const Icon(Icons.location_disabled, color: Colors.black),
    );
  }

  void _handleClick() async {
    Position locationData = await Geolocator.getCurrentPosition();
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locationData.latitude, locationData.longitude), 18));
  }
}
