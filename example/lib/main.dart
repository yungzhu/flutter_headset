import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_headset/flutter_headset.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HeadsetState _state = HeadsetState.connect;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      _state = await FlutterHeadset.getCurrentState;
    } catch (e) {
      print(e);
    }

    FlutterHeadset.setListener((state) {
      _state = state;
      setState(() {});
    });

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_state'),
        ),
      ),
    );
  }
}
