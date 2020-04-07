package com.yung.flutter_headset;

import androidx.annotation.NonNull;
import android.content.Intent;
import android.content.IntentFilter;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterHeadsetPlugin */
public class FlutterHeadsetPlugin implements FlutterPlugin, MethodCallHandler {
  public static int currentState = 0;
  private static MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_headset");
    channel.setMethodCallHandler(new FlutterHeadsetPlugin());
    HeadsetBroadcastReceiver headsetReceiver = new HeadsetBroadcastReceiver(headsetEventListener);
    IntentFilter filter = new IntentFilter(Intent.ACTION_HEADSET_PLUG);
    flutterPluginBinding.getApplicationContext().registerReceiver(headsetReceiver, filter);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "flutter_headset");
    channel.setMethodCallHandler(new FlutterHeadsetPlugin());
    HeadsetBroadcastReceiver headsetReceiver = new HeadsetBroadcastReceiver(headsetEventListener);
    IntentFilter filter = new IntentFilter(Intent.ACTION_HEADSET_PLUG);
    registrar.activeContext().registerReceiver(headsetReceiver, filter);
  }

  static HeadsetEventListener headsetEventListener = new HeadsetEventListener() {
    @Override
    public void onHeadsetConnect() {
      channel.invokeMethod("connect", "true");
    }

    @Override
    public void onHeadsetDisconnect() {
      channel.invokeMethod("disconnect", "true");
    }
  };

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getCurrentState")) {
      result.success(currentState);
    } else {
      result.notImplemented();
    }
  }
}
