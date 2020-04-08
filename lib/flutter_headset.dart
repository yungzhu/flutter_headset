import 'dart:async';
import 'package:flutter/services.dart';

enum InputType {
  /// unknow
  unknow,

  /// input
  receiver,

  /// out speaker
  speaker,

  /// headset
  headphones,

  /// bluetooth
  bluetooth,

  /// car
  carAudio,
}

class Input {
  final String name;
  final int _type;
  InputType get type {
    return InputType.values[_type];
  }

  const Input(this.name, this._type);

  @override
  String toString() {
    return "name:$name,type:$type";
  }
}

class FlutterHeadset {
  static const MethodChannel _channel = const MethodChannel('flutter_headset');
  static void Function() _onChanged;

  static Future<Input> getCurrentOutput() async {
    final List<dynamic> data = await _channel.invokeMethod('getCurrentOutput');
    return Input(data[0], int.parse(data[1]));
  }

  static Future<List<Input>> getAvailableInputs() async {
    final List<dynamic> list =
        await _channel.invokeMethod('getAvailableInputs');

    List<Input> arr = [];
    list.forEach((data) {
      arr.add(Input(data[0], int.parse(data[1])));
    });
    return arr;
  }

  static Future<bool> changeToSpeaker() async {
    return await _channel.invokeMethod('changeToSpeaker');
  }

  static Future<bool> changeToReceiver() async {
    return await _channel.invokeMethod('changeToReceiver');
  }

  static Future<bool> changeToHeadphones() async {
    return await _channel.invokeMethod('changeToHeadphones');
  }

  static Future<bool> changeToBluetooth() async {
    return await _channel.invokeMethod('changeToBluetooth');
  }

  static Future<bool> changeToCarAudio() async {
    return await _channel.invokeMethod('changeToCarAudio');
  }

  static void setListener(void Function() onChanged) {
    FlutterHeadset._onChanged = onChanged;
    _channel.setMethodCallHandler(_methodHandle);
  }

  static Future<void> _methodHandle(MethodCall call) async {
    if (_onChanged == null) return;
    switch (call.method) {
      case "inputChanged":
        return _onChanged();
      default:
        break;
    }
  }
}
