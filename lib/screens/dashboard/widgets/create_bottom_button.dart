import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_form.dart';

class CreateBottomButton extends StatelessWidget {
  const CreateBottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black12,
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateFormView()),
          ),
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: const <Widget>[
              Icon(
                Icons.add_location_alt,
              ),
              Text('Marker toevoegen'),
            ],
          ),
        ),
      ),
    );
  }
}
