import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLocationButton extends StatefulWidget {
  const MyLocationButton({Key? key, required this.disabled}) : super(key: key);

  final bool disabled;

  @override
  _MyLocationButtonState createState() => _MyLocationButtonState();
}

class _MyLocationButtonState extends State<MyLocationButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.disabled ? _handleClick : null,
      backgroundColor: widget.disabled ? Colors.white : Colors.grey,
      child: widget.disabled ?
      const Icon(Icons.my_location, color: Colors.black) :
      const Icon(Icons.location_disabled, color: Colors.black),
    );
  }

  void _handleClick() {

  }
}
