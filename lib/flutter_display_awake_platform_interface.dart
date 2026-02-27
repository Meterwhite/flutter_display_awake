import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_display_awake_method_channel.dart';

abstract class FlutterDisplayAwakePlatform extends PlatformInterface {
  /// Constructs a FlutterDisplayAwakePlatform.
  FlutterDisplayAwakePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDisplayAwakePlatform _instance =
      MethodChannelFlutterDisplayAwake();

  /// The default instance of [FlutterDisplayAwakePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDisplayAwake].
  static FlutterDisplayAwakePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDisplayAwakePlatform] when
  /// they register themselves.
  static set instance(FlutterDisplayAwakePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> keepScreenOn() {
    throw UnimplementedError('keepScreenOn() has not been implemented.');
  }

  Future<void> keepScreenOff() {
    throw UnimplementedError('keepScreenOff() has not been implemented.');
  }

  Future<bool> isKeptOn() {
    throw UnimplementedError('isKeptOn() has not been implemented.');
  }
}
