import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkerPopupButton extends StatelessWidget {
  final String label;
  final void Function() onPress;
  final Color backgroundColor;
  final Color labelColor;

  const MarkerPopupButton({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.labelColor,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          child: Text(label, style: TextStyle(color: labelColor)),
          onPressed: onPress,
          fillColor: const Color(0xFFA6A6A6),
        ),
      ),
    );
  }
}
