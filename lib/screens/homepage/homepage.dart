import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: const Text(
          "ECOCHAT",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color(0xff33835c),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
        showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
        child: Center(child: Text('This is a modal bottom sheet')),
        ))
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
