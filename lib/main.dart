import 'package:flutter/material.dart';
import 'package:med_health_app/pages/splash.dart';
import 'package:med_health_app/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: greenColor),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
