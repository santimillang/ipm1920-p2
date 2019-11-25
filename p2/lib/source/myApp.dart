import 'package:flutter/material.dart';
import 'package:p2/source/screens/homeScreen.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.orange),
      title: 'IPM P2'
    );
  }
}
