#import "FlutterHeadsetPlugin.h"
#if __has_include(<flutter_headset/flutter_headset-Swift.h>)
#import <flutter_headset/flutter_headset-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_headset-Swift.h"
#endif

@implementation FlutterHeadsetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterHeadsetPlugin registerWithRegistrar:registrar];
}
@end
