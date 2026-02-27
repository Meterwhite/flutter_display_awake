import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_display_awake/flutter_display_awake_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterDisplayAwake platform =
      MethodChannelFlutterDisplayAwake();
  const MethodChannel channel = MethodChannel('flutter_display_awake');
  final List<String> calledMethods = <String>[];

  setUp(() {
    calledMethods.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        calledMethods.add(methodCall.method);
        if (methodCall.method == 'isKeptOn') {
          return true;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('keepScreenOn', () async {
    await expectLater(platform.keepScreenOn(), completes);
    expect(calledMethods, contains('keepScreenOn'));
  });

  test('keepScreenOff', () async {
    await expectLater(platform.keepScreenOff(), completes);
    expect(calledMethods, contains('keepScreenOff'));
  });

  test('isKeptOn', () async {
    final bool result = await platform.isKeptOn();
    expect(result, true);
    expect(calledMethods, contains('isKeptOn'));
  });

  test('isKeptOn returns false when channel returns null', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        calledMethods.add(methodCall.method);
        return null;
      },
    );

    final bool result = await platform.isKeptOn();
    expect(result, false);
    expect(calledMethods, contains('isKeptOn'));
  });
}
