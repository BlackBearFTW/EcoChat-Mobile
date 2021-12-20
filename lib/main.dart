import 'package:ecochat_app/screens/homepage/widgets/marker_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const MaterialApp(
      title: 'EcoChat',
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
