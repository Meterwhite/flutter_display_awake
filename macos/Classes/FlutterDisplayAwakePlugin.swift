import Cocoa
import FlutterMacOS
import IOKit.pwr_mgt

public class FlutterDisplayAwakePlugin: NSObject, FlutterPlugin {
  private var assertionID: IOPMAssertionID = 0
  private var isAssertionActive = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_display_awake", binaryMessenger: registrar.messenger)
    let instance = FlutterDisplayAwakePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "keepScreenOn":
      if !isAssertionActive {
        let success = IOPMAssertionCreateWithName(
          kIOPMAssertionTypeNoDisplaySleep as CFString,
          IOPMAssertionLevel(kIOPMAssertionLevelOn),
          "flutter_display_awake" as CFString,
          &assertionID
        )
        isAssertionActive = (success == kIOReturnSuccess)
      }
      result(nil)
    case "keepScreenOff":
      if isAssertionActive {
        IOPMAssertionRelease(assertionID)
        isAssertionActive = false
      }
      result(nil)
    case "isKeptOn":
      result(isAssertionActive)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
