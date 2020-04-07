import Flutter
import UIKit
import AVFoundation

public class SwiftFlutterHeadsetPlugin: NSObject, FlutterPlugin {
    var channel : FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_headset", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterHeadsetPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.channel = channel;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getCurrentState"){
            result(headsetIsConnect())
        }
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    public override init() {
        super.init()
        registerAudioRouteChangeBlock()
    }
    
    func registerAudioRouteChangeBlock(){
        NotificationCenter.default.addObserver( forName:AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance(), queue: nil) { notification in
            guard let userInfo = notification.userInfo,
                let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                    return
            }
            switch reason {
            case .newDeviceAvailable:
                self.channel!.invokeMethod("connect",arguments: "true")
            case .oldDeviceUnavailable:
                self.channel!.invokeMethod("disconnect",arguments: "true")
            default: ()
            }
        }
    }
    
    func headsetIsConnect() -> Int  {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for output in currentRoute.outputs {
            //print("hello \(output.portType)")
            if output.portType == AVAudioSession.Port.headphones {
                return 1
            }else if output.portType == AVAudioSession.Port.bluetoothA2DP{
                return 1
            }else{
                return 0;
            }
        }
        return 0
    }
}
