import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let raw = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String {
      let key = raw.trimmingCharacters(in: .whitespacesAndNewlines)
      let invalid =
        key.isEmpty
        || key == "$(GOOGLE_MAPS_API_KEY)"
        || key == "YOUR_GOOGLE_MAPS_API_KEY_HERE"
      if !invalid {
        GMSServices.provideAPIKey(key)
      }
    }
    // Required for plugins that use platform views (e.g. google_maps_flutter on iOS).
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_: FlutterImplicitEngineBridge) {
    // Plugins registered in application(_:didFinishLaunchingWithOptions:).
  }
}
