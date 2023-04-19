import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/screens/draw_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MNIST DIGIT RECOGNIZER',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
        ),
      ),
      home: DrawScreen(),
    );
  }
}
