import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Baju',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
