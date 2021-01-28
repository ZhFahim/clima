import 'package:flutter/material.dart';
import 'package:clima/screens/loading_screen.dart';

void main() {
  runApp(Clima());
}

class Clima extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}
