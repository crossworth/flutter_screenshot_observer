import Flutter
import UIKit

// refer to https://github.com/flutter-moum/flutter_screenshot_callback
public class SwiftScreenshotObserverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "screenshot_observer", binaryMessenger: registrar.messenger())
    let instance = SwiftScreenshotObserverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "initialize"){
        if(SwiftScreenshotObserverPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotObserverPlugin.observer!);
            SwiftScreenshotObserverPlugin.observer = nil;
        }
        SwiftScreenshotObserverPlugin.observer = NotificationCenter.default.addObserver(
          forName: UIApplication.userDidTakeScreenshotNotification,
          object: nil,
          queue: .main) { notification in
          if let channel = SwiftScreenshotObserverPlugin.channel {
            channel.invokeMethod("onScreenshot", arguments: nil)
          }

          result("screenshot called")
      }
      result("initialize")
    }else if(call.method == "dispose"){
        if(SwiftScreenshotObserverPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotObserverPlugin.observer!);
            SwiftScreenshotObserverPlugin.observer = nil;
        }
        result("dispose")
    }else{
      result("")
    }
  }
    
  deinit {
      if(SwiftScreenshotObserverPlugin.observer != nil) {
        NotificationCenter.default.removeObserver(SwiftScreenshotObserverPlugin.observer!);
        SwiftScreenshotObserverPlugin.observer = nil;
      }
  }
}
