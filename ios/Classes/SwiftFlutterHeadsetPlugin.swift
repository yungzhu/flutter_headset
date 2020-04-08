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
        if (call.method == "getCurrentOutput"){
            result(getCurrentOutput())
        }
        else if(call.method == "getAvailableInputs"){
            result(getAvailableInputs())
        }
        else if(call.method == "changeInput"){
            result(changeInput((call.arguments as! [String])[0]))
        }
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    func getCurrentOutput() -> [String]  {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
//        print("hello \(currentRoute.outputs)")
        for output in currentRoute.outputs {
            return [output.uid,output.portName,output.portType.rawValue];
        }
        return ["","",""];
    }
    
    func getAvailableInputs() -> [[String]]  {
        var arr = [[String]]()
        if let inputs = AVAudioSession.sharedInstance().availableInputs {
            print("availableInputs \(inputs.count)")
            for input in inputs {
                arr.append([input.uid,input.portName,input.portType.rawValue]);
             }
        }
        return arr;
    }
    
    func changeInput(_ uid:String) -> Bool{
        if let inputs = AVAudioSession.sharedInstance().availableInputs {
            print("availableInputs \(inputs.count)")
            for input in inputs {
                if(input.uid == uid){
                    try? AVAudioSession.sharedInstance().setPreferredInput(input);
                    return true;
                }
             }
        }
        return false;
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
            print("registerAudioRouteChangeBlock \(reason)");
            self.channel!.invokeMethod("inputChanged",arguments: "true")
//            switch reason {
//            case .newDeviceAvailable:
//                self.channel!.invokeMethod("inputChanged",arguments: "true")
//            case .oldDeviceUnavailable:
//                self.channel!.invokeMethod("inputChanged",arguments: "true")
//            default: ()
//            }
        }
    }

//    func getInputType(_ portType:AVAudioSession.Port) -> Int{
//        switch portType {
//            case AVAudioSession.Port.builtInReceiver:
//                return 0;
//            case AVAudioSession.Port.builtInSpeaker:
//                return 1;
//            case AVAudioSession.Port.headphones:
//                return 2;
//            case AVAudioSession.Port.bluetoothA2DP:
//                return 3;
//            case AVAudioSession.Port.carAudio:
//                return 4;
//            default:
//                return -1;
//        }
//    }

    // func switchBluetooth() -> Bool{
    //     if let inputs = AVAudioSession.sharedInstance().availableInputs {  
    //         do {
    //             for input in inputs {  
    //                 if input.portType == AVAudioSession.Port.bluetoothA2DP{
    //                     let _ = try? AVAudioSession.sharedInstance().setPreferredInput(input);
    //                     return true;
    //                 }
    //                 else if input.portType == AVAudioSession.Port.bluetoothHFP{
    //                     let _ = try? AVAudioSession.sharedInstance().setPreferredInput(input);
    //                     return true;
    //                 }
    //             }  
    //         } catch let error {
    //             print("SwitchBluetooth error \(error)")
    //         }
    //     }
    //     return false;
    // }
}
