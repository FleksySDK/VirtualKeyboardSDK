import 'package:flutter/material.dart';
import 'package:flutterintegration/home/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Fleksy Flutter sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}

