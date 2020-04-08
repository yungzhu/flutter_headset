import 'dart:async';
import 'package:flutter/services.dart';

enum InputType {
  /// 内置
  builtIn,

  /// 外放
  speaker,

  /// 有线耳机
  headphones,

  /// 蓝牙耳机
  bluetooth,

  /// 车载
  car
}

class Input {
  final String uid;
  final String name;
  final String port;
  // final InputType type;
  const Input(this.uid, this.name, this.port);
}

class FlutterHeadset {
  static const MethodChannel _channel = const MethodChannel('flutter_headset');
  static void Function() _onChanged;

  static Future<Input> getCurrentOutput() async {
    final List<dynamic> data = await _channel.invokeMethod('getCurrentOutput');
    print("current: $data");
    return Input(data[0], data[1], data[2]);
  }

  static Future<List<Input>> getAvailableInputs() async {
    final List<dynamic> list =
        await _channel.invokeMethod('getAvailableInputs');
    print("available: $list");

    List<Input> arr = [];
    list.forEach((data) {
      arr.add(Input(data[0], data[1], data[2]));
    });
    return arr;
  }

  static void setListener(void Function() onChanged) {
    FlutterHeadset._onChanged = onChanged;
    _channel.setMethodCallHandler(_methodHandle);
  }

  static Future<bool> changeInput(InputType input) async {
    final bool res = await _channel.invokeMethod('changeInput', input.index);
    return res;
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
