import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let counter = """
    {
        "counter": 2
    }
    """
    let dir = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.dk.miracle.flutter-native-widget-hackday-2021")!
    let filename = dir.appendingPathComponent("counter.json")
    print(filename)
    
    try! counter.write(to: filename, atomically: true, encoding: .utf8)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
