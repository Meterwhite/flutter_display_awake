import Flutter
import UIKit

public class FlutterDisplayAwakePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_display_awake", binaryMessenger: registrar.messenger())
    let instance = FlutterDisplayAwakePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "keepScreenOn":
      DispatchQueue.main.async {
        UIApplication.shared.isIdleTimerDisabled = true
      }
      result(nil)
    case "keepScreenOff":
      DispatchQueue.main.async {
        UIApplication.shared.isIdleTimerDisabled = false
      }
      result(nil)
    case "isKeptOn":
      DispatchQueue.main.async {
        result(UIApplication.shared.isIdleTimerDisabled)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
