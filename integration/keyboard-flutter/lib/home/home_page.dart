import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterintegration/home/widgets/status_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: build(context));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const platform = MethodChannel('flutter.native/helper');

  bool _isImeEnabled = false;
  bool _isImeSelected = false;

  Future<void> enableIme() async {
    try {
      await platform.invokeMethod('enableIme');
      refresh();
    } on PlatformException catch (e) {
      log("Failed to Invoke: '${e.message}'");
    }
  }

  Future<void> selectIme() async {
    try {
      await platform.invokeMethod('selectIme');
      refresh();
    } on PlatformException catch (e) {
      log("Failed to Invoke: '${e.message}'");
    }
  }

  Future<void> refresh() async {
    try {
      _isImeEnabled = await platform.invokeMethod('isImeEnabled');
      _isImeSelected = await platform.invokeMethod('isImeSelected');
    } on PlatformException catch (e) {
      log("Failed to Invoke: '${e.message}'");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(title: const Text('Fleksy SDK')),
            StatusRow('Enable ime: ', enableIme, _isImeEnabled),
            if (Platform.isAndroid) StatusRow('Select ime: ', selectIme, _isImeSelected),
            Expanded(child: Container(),),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: TextField())
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    refresh();
  }
}
