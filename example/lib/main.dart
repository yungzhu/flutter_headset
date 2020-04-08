import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_headset/flutter_headset.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Input _currentInput = Input("none", "none", "none");
  List<Input> _availableInputs = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    FlutterHeadset.setListener(() async {
      print("-----changed-------");
      await _getInput();
      setState(() {});
    });

    await _getInput();
    if (!mounted) return;
    setState(() {});
  }

  _getInput() async {
    _currentInput = await FlutterHeadset.getCurrentOutput();
    _availableInputs = await FlutterHeadset.getAvailableInputs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text("current output:${_currentInput.name}"),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    Input input = _availableInputs[index];
                    return Row(
                      children: <Widget>[
                        Expanded(child: Text("${input.uid}")),
                        Expanded(child: Text("${input.name}")),
                        Expanded(child: Text("${input.port}")),
                      ],
                    );
                  },
                  itemCount: _availableInputs.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var res = await FlutterHeadset.changeInput(InputType.bluetooth);
            print(res);
          },
        ),
      ),
    );
  }
}
