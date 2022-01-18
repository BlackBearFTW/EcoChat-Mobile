import 'package:flutter/cupertino.dart';

class MarkerPopupRow extends StatelessWidget {
  String label = "";
  String value = "";

  MarkerPopupRow(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)]
    );
  }
}
