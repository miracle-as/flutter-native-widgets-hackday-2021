import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    
//    let counter = """
//    {
//        "counter": 2
//    }
//    """
    
//    let filename = dir.appendingPathComponent("counter.json")
//    print(filename)
//
//    try! counter.write(to: filename, atomically: true, encoding: .utf8)
    
    let methodChannel = FlutterMethodChannel(name: "dk.miracle.flutter-native-widget-hackday-2021.appGroup", binaryMessenger: (self.window.rootViewController as! FlutterViewController).binaryMessenger)
    methodChannel.setMethodCallHandler { (call, result) in
        if call.method == "getAppGroupDir" {
            // "group.dk.miracle.flutter-native-widget-hackday-2021"
            let dir = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: call.arguments as! String)!
            result(dir.path)
        } else if call.method == "reloadAllTimelines" {
            WidgetCenter.shared.reloadAllTimelines()
            result(nil)
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
