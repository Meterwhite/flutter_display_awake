# flutter_display_awake example

This example demonstrates how to:

- enable keep-awake mode with `keepScreenOn()`
- disable keep-awake mode with `keepScreenOff()`
- query current keep-awake state with `isKeptOn()`

## Run

From the plugin root:

```bash
cd example
flutter pub get
flutter run
```

## What to expect

- Tap **Keep Screen On** to request wake-lock behavior.
- Tap **Allow Screen Off** to restore default behavior.
- The status text updates based on `isKeptOn()` to show whether the screen is currently kept awake.
