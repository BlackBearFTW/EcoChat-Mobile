import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // @override
  // void initState() {
  //   //  TODO: Get initial marker data
  // }
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: const Text(
          "ECOCHAT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff33835c),
      ),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(50.94284, 5.921534),
          zoom: 14.4746,
        ),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        compassEnabled: false,
     
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // showModalBottomSheet(
          //     barrierColor: Colors.white.withOpacity(0),
          //     backgroundColor: Colors.red,
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(16),
          //           topRight: Radius.circular(16)),
          //     ),
          //     context: context,
          //     builder: (BuildContext context) => SizedBox(
          //           height: MediaQuery.of(context).size.height * 0.25,
          //           child: const Center(
          //               child: Text('This is a modal bottom sheet')),
          //         ))
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
