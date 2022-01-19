import 'package:ecochat_app/models/marker_model.dart';
import 'package:ecochat_app/screens/dashboard/widgets/marker_editor.dart';
import 'package:flutter/material.dart';
import 'package:ecochat_app/services/markers_api.dart';

class CreateFormView extends StatefulWidget {
  String jsonWebToken;

  CreateFormView(this.jsonWebToken, {Key? key}) : super(key: key);

  @override
  _CreateFormViewState createState() => _CreateFormViewState();
}

class _CreateFormViewState extends State<CreateFormView> {
  late MarkersApi markersApi;

  @override
  void initState() {
    super.initState();
    markersApi = MarkersApi(widget.jsonWebToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        titleSpacing: 0,
        backgroundColor: const Color(0xff7672FF),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkerEditor(
              marker: MarkerModel.empty(),
              onSave: (MarkerModel marker) {
                markersApi.createMarker(marker);
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ),
          ],
        ),
      )
    );
  }

}
