import 'flutter_display_awake_platform_interface.dart';

class FlutterDisplayAwake {
  Future<void> keepScreenOn() {
    return FlutterDisplayAwakePlatform.instance.keepScreenOn();
  }

  Future<void> keepScreenOff() {
    return FlutterDisplayAwakePlatform.instance.keepScreenOff();
  }

  Future<bool> isKeptOn() {
    return FlutterDisplayAwakePlatform.instance.isKeptOn();
  }
}
