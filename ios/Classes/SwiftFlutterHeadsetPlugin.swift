import Flutter
import UIKit
import AVFoundation

public class SwiftFlutterHeadsetPlugin: NSObject, FlutterPlugin {
  var _channel : FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_headset", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterHeadsetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    instance._channel = channel;
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getCurrentState"){
        result(_headsetIsConnect())
    }
    result("iOS " + UIDevice.current.systemVersion)
  }

  public override init() {
      super.init()
      _registerAudioRouteChangeBlock()
  }

  func _registerAudioRouteChangeBlock(){
      NotificationCenter.default.addObserver( forName:AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance(), queue: nil) { notification in
          guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                  return
          }
          switch reason {
          case .newDeviceAvailable:
              self._channel!.invokeMethod("connect",arguments: "true")
          case .oldDeviceUnavailable:
              self._channel!.invokeMethod("disconnect",arguments: "true")
          default: ()
          }
      }
  }

  func _headsetIsConnect() -> Int  {
      let currentRoute = AVAudioSession.sharedInstance().currentRoute
      for output in currentRoute.outputs {
          if output.portType == AVAudioSession.Port.headphones {
              return 1
          }else {
              return 0
          }
      }
      return 0
  }
}
