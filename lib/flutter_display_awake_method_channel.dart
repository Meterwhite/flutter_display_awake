import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_display_awake_platform_interface.dart';

/// An implementation of [FlutterDisplayAwakePlatform] that uses method channels.
class MethodChannelFlutterDisplayAwake extends FlutterDisplayAwakePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_display_awake');

  @override
  Future<void> keepScreenOn() async {
    await methodChannel.invokeMethod<void>('keepScreenOn');
  }

  @override
  Future<void> keepScreenOff() async {
    await methodChannel.invokeMethod<void>('keepScreenOff');
  }

  @override
  Future<bool> isKeptOn() async {
    final bool? result = await methodChannel.invokeMethod<bool>('isKeptOn');
    return result ?? false;
  }
}
