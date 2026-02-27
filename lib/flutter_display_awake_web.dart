import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'flutter_display_awake_platform_interface.dart';

/// A web implementation of the FlutterDisplayAwakePlatform of the FlutterDisplayAwake plugin.
class FlutterDisplayAwakeWeb extends FlutterDisplayAwakePlatform {
  /// Constructs a FlutterDisplayAwakeWeb
  FlutterDisplayAwakeWeb();

  static void registerWith(Registrar registrar) {
    FlutterDisplayAwakePlatform.instance = FlutterDisplayAwakeWeb();
  }

  web.WakeLockSentinel? _wakeLockSentinel;
  StreamSubscription<web.Event>? _visibilitySub;

  Future<void> _requestWakeLock() async {
    try {
      final sentinel =
          await web.window.navigator.wakeLock.request('screen').toDart;
      _wakeLockSentinel = sentinel;

      sentinel.addEventListener(
        'release',
        (web.Event _) {
          _wakeLockSentinel = null;
        }.toJS,
      );
    } catch (_) {}
  }

  @override
  Future<void> keepScreenOn() async {
    await _requestWakeLock();

    _visibilitySub ??= web.document.onVisibilityChange.listen((_) async {
      if (web.document.visibilityState == 'visible' &&
          _wakeLockSentinel == null) {
        try {
          await _requestWakeLock();
        } catch (_) {}
      }
    });
  }

  @override
  Future<void> keepScreenOff() async {
    if (_wakeLockSentinel == null) return;
    try {
      await _wakeLockSentinel!.release().toDart;
    } catch (_) {}
    _wakeLockSentinel = null;
    await _visibilitySub?.cancel();
    _visibilitySub = null;
  }

  @override
  Future<bool> isKeptOn() async {
    if (_wakeLockSentinel == null) return false;
    return !_wakeLockSentinel!.released;
  }
}
