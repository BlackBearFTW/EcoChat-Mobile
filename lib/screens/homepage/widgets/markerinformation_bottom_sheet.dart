import 'package:flutter/material.dart';

class MarkerInformationBottomSheet extends StatelessWidget {
  const MarkerInformationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BottomSheet(onClosing: () => {}, builder: (context) {

        return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: ElevatedButton(
              child: const Text("Close Bottom Sheet"),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.green,
              ),
              onPressed: () => {},
            )
        );
      });
}