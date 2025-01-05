import 'package:flutter/material.dart';
import 'widgets/students.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentsScreen(),
    );
  }
}
