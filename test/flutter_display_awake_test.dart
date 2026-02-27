import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_display_awake/flutter_display_awake.dart';
import 'package:flutter_display_awake/flutter_display_awake_platform_interface.dart';
import 'package:flutter_display_awake/flutter_display_awake_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDisplayAwakePlatform
    with MockPlatformInterfaceMixin
    implements FlutterDisplayAwakePlatform {
  @override
  Future<void> keepScreenOn() => Future.value();

  @override
  Future<void> keepScreenOff() => Future.value();

  @override
  Future<bool> isKeptOn() => Future.value(false);
}

void main() {
  final FlutterDisplayAwakePlatform initialPlatform =
      FlutterDisplayAwakePlatform.instance;

  test('$MethodChannelFlutterDisplayAwake is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDisplayAwake>());
  });

  test('keepScreenOn', () async {
    FlutterDisplayAwake flutterDisplayAwakePlugin = FlutterDisplayAwake();
    MockFlutterDisplayAwakePlatform fakePlatform =
        MockFlutterDisplayAwakePlatform();
    FlutterDisplayAwakePlatform.instance = fakePlatform;

    await expectLater(flutterDisplayAwakePlugin.keepScreenOn(), completes);
  });

  test('keepScreenOff', () async {
    FlutterDisplayAwake flutterDisplayAwakePlugin = FlutterDisplayAwake();
    MockFlutterDisplayAwakePlatform fakePlatform =
        MockFlutterDisplayAwakePlatform();
    FlutterDisplayAwakePlatform.instance = fakePlatform;

    await expectLater(flutterDisplayAwakePlugin.keepScreenOff(), completes);
  });

  test('isKeptOn', () async {
    FlutterDisplayAwake flutterDisplayAwakePlugin = FlutterDisplayAwake();
    MockFlutterDisplayAwakePlatform fakePlatform =
        MockFlutterDisplayAwakePlatform();
    FlutterDisplayAwakePlatform.instance = fakePlatform;

    final val = await flutterDisplayAwakePlugin.isKeptOn();
    expect(val, false);
  });
}
