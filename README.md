# flutter_display_awake

[![pub package](https://img.shields.io/pub/v/flutter_display_awake.svg)](https://pub.dev/packages/flutter_display_awake)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue?logo=github)](https://github.com/youruser/flutter_display_awake)


Keep the device screen awake in Flutter apps.

`flutter_display_awake` allows your Flutter app to explicitly request a keep-awake state while a specific screen or flow is active (for example, video playback, reading mode, navigation, workouts, or kiosk/check-in pages). When enabled, the plugin asks the underlying platform to prevent automatic screen dimming/locking and display sleep for the current app session; when you no longer need that behavior, you can call `keepScreenOff()` to immediately restore the system's default power and lock policy. You can also call `isKeptOn()` to check whether the plugin is currently holding this keep-awake request.

## Features

- Keep the screen on (`keepScreenOn`)
- Restore default sleep behavior (`keepScreenOff`)
- Query current kept-on state (`isKeptOn`)

## Platform support

| Platform | `keepScreenOn` | `keepScreenOff` | `isKeptOn` |
| --- | --- | --- | --- |
| Android | ✅ | ✅ | ✅ |
| iOS | ✅ | ✅ | ✅ |
| macOS | ✅ | ✅ | ✅ |
| Linux | ✅ | ✅ | ✅ |
| Windows | ✅ | ✅ | ✅ |
| Web | ✅ | ✅ | ✅ |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
	flutter_display_awake: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:flutter_display_awake/flutter_display_awake.dart';

final plugin = FlutterDisplayAwake();

await plugin.keepScreenOn();

await plugin.keepScreenOff();

bool? isKeptOn;
try {
	isKeptOn = await plugin.isKeptOn();
} catch (_) {
	isKeptOn = null; // If a platform-specific runtime failure occurs.
}
```

## API

### `Future<void> keepScreenOn()`

Requests the platform to keep the screen awake.

### `Future<void> keepScreenOff()`

Restores default platform sleep/lock behavior.

### `Future<bool> isKeptOn()`

Returns whether the plugin is currently keeping the screen on.

## Notes

- On mobile and desktop, this plugin controls app/session-level wake behavior. System policies (battery saver, admin policy, OS constraints) may still override it.
- On Web, behavior depends on browser support for the Screen Wake Lock API and page visibility/user interaction rules.

## Example

See the runnable sample app in [example](example).
