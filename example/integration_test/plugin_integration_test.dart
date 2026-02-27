// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_display_awake/flutter_display_awake.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('keepScreenOn/keepScreenOff test', (WidgetTester tester) async {
    final FlutterDisplayAwake plugin = FlutterDisplayAwake();
    await expectLater(plugin.keepScreenOn(), completes);
    await expectLater(plugin.keepScreenOff(), completes);
  });
}
