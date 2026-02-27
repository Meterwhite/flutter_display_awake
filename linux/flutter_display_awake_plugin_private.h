#include <flutter_linux/flutter_linux.h>

#include "include/flutter_display_awake/flutter_display_awake_plugin.h"

// This file exposes some plugin internals for unit testing. See
// https://github.com/flutter/flutter/issues/88724 for current limitations
// in the unit-testable API.

typedef struct _FlutterDisplayAwakePlugin FlutterDisplayAwakePlugin;

FlMethodResponse *keep_screen_on(FlutterDisplayAwakePlugin* self);
FlMethodResponse *keep_screen_off(FlutterDisplayAwakePlugin* self);
FlMethodResponse *is_kept_on(FlutterDisplayAwakePlugin* self);

FlutterDisplayAwakePlugin* flutter_display_awake_plugin_new_for_test();
void flutter_display_awake_plugin_free_for_test(FlutterDisplayAwakePlugin* self);
