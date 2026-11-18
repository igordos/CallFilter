import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "call_filter/platform",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getCapabilities":
        result([
          "platform": "iOS",
          "callScreening": "unavailable",
          "callerDisplayName": "unavailable",
          "callDirectory": "limited",
          "numberBlocking": "limited",
          "details": "Call Directory can only use prepared number mappings. "
            + "It cannot evaluate RegExp patterns or caller names at call time.",
        ])
      case "syncSnapshot":
        guard let raw = call.arguments as? String else {
          result(
            FlutterError(
              code: "INVALID_ARGUMENT",
              message: "Snapshot must be a JSON string.",
              details: nil
            )
          )
          return
        }
        result(CallFilterSnapshotStore.save(raw))
      case "openSystemSettings":
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
          result(
            FlutterError(
              code: "UNAVAILABLE",
              message: "Could not create the Settings URL.",
              details: nil
            )
          )
          return
        }
        UIApplication.shared.open(url)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
