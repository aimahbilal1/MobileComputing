import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Notes App',
  theme: ThemeData(
    primarySwatch: Colors.deepPurple,
    useMaterial3: true,
  ),
  home: SplashScreen(),
);
  }
}
