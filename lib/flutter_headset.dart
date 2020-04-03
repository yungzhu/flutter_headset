import 'dart:async';
import 'package:flutter/services.dart';

enum HeadsetState { connect, disconnect }

class FlutterHeadset {
  static const MethodChannel _channel = const MethodChannel('flutter_headset');
  static void Function(HeadsetState state) _onChanged;

  static Future<HeadsetState> get getCurrentState async {
    final int state = await _channel.invokeMethod('getCurrentState');
    return HeadsetState.values[state];
  }

  static void setListener(void Function(HeadsetState payload) onChanged) {
    FlutterHeadset._onChanged = onChanged;
    _channel.setMethodCallHandler(_methodHandle);
  }

  static Future<void> _methodHandle(MethodCall call) async {
    if (_onChanged == null) return;
    switch (call.method) {
      case "connect":
        return _onChanged(HeadsetState.connect);
      case "disconnect":
        return _onChanged(HeadsetState.disconnect);
      default:
        break;
    }
  }
}