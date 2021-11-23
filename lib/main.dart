import 'package:flutter/material.dart';

import 'screens/homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EcoChat',
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
