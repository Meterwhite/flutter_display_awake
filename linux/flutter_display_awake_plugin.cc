#include "include/flutter_display_awake/flutter_display_awake_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <gio/gio.h>

#include <cstring>

#include "flutter_display_awake_plugin_private.h"

#define FLUTTER_DISPLAY_AWAKE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_display_awake_plugin_get_type(), \
                              FlutterDisplayAwakePlugin))

struct _FlutterDisplayAwakePlugin {
  GObject parent_instance;
  guint32 inhibit_cookie;
  gboolean is_inhibited;
};

G_DEFINE_TYPE(FlutterDisplayAwakePlugin, flutter_display_awake_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void flutter_display_awake_plugin_handle_method_call(
    FlutterDisplayAwakePlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "keepScreenOn") == 0) {
    response = keep_screen_on(self);
  } else if (strcmp(method, "keepScreenOff") == 0) {
    response = keep_screen_off(self);
  } else if (strcmp(method, "isKeptOn") == 0) {
    response = is_kept_on(self);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* keep_screen_on(FlutterDisplayAwakePlugin* self) {
  if (!self->is_inhibited) {
    g_autoptr(GError) error = nullptr;
    g_autoptr(GDBusProxy) proxy = g_dbus_proxy_new_for_bus_sync(
        G_BUS_TYPE_SESSION,
        G_DBUS_PROXY_FLAGS_NONE,
        nullptr,
        "org.freedesktop.ScreenSaver",
        "/org/freedesktop/ScreenSaver",
        "org.freedesktop.ScreenSaver",
        nullptr,
        &error);
    if (proxy != nullptr) {
      g_autoptr(GVariant) result = g_dbus_proxy_call_sync(
          proxy,
          "Inhibit",
          g_variant_new("(ss)", "flutter_display_awake", "keep screen on"),
          G_DBUS_CALL_FLAGS_NONE,
          -1,
          nullptr,
          &error);
      if (result != nullptr) {
        g_variant_get(result, "(u)", &self->inhibit_cookie);
        self->is_inhibited = TRUE;
      }
    }
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* keep_screen_off(FlutterDisplayAwakePlugin* self) {
  if (self->is_inhibited) {
    g_autoptr(GError) error = nullptr;
    g_autoptr(GDBusProxy) proxy = g_dbus_proxy_new_for_bus_sync(
        G_BUS_TYPE_SESSION,
        G_DBUS_PROXY_FLAGS_NONE,
        nullptr,
        "org.freedesktop.ScreenSaver",
        "/org/freedesktop/ScreenSaver",
        "org.freedesktop.ScreenSaver",
        nullptr,
        &error);
    if (proxy != nullptr) {
      g_dbus_proxy_call_sync(
          proxy,
          "UnInhibit",
          g_variant_new("(u)", self->inhibit_cookie),
          G_DBUS_CALL_FLAGS_NONE,
          -1,
          nullptr,
          &error);
      self->is_inhibited = FALSE;
    }
  }
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

FlMethodResponse* is_kept_on(FlutterDisplayAwakePlugin* self) {
  return FL_METHOD_RESPONSE(
      fl_method_success_response_new(fl_value_new_bool(self->is_inhibited)));
}

FlutterDisplayAwakePlugin* flutter_display_awake_plugin_new_for_test() {
  return FLUTTER_DISPLAY_AWAKE_PLUGIN(
      g_object_new(flutter_display_awake_plugin_get_type(), nullptr));
}

void flutter_display_awake_plugin_free_for_test(FlutterDisplayAwakePlugin* self) {
  g_object_unref(self);
}

static void flutter_display_awake_plugin_dispose(GObject* object) {
  FlutterDisplayAwakePlugin* self = FLUTTER_DISPLAY_AWAKE_PLUGIN(object);
  if (self->is_inhibited) {
    keep_screen_off(self);
  }
  G_OBJECT_CLASS(flutter_display_awake_plugin_parent_class)->dispose(object);
}

static void flutter_display_awake_plugin_class_init(FlutterDisplayAwakePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_display_awake_plugin_dispose;
}

static void flutter_display_awake_plugin_init(FlutterDisplayAwakePlugin* self) {
  self->inhibit_cookie = 0;
  self->is_inhibited = FALSE;
}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlutterDisplayAwakePlugin* plugin = FLUTTER_DISPLAY_AWAKE_PLUGIN(user_data);
  flutter_display_awake_plugin_handle_method_call(plugin, method_call);
}

void flutter_display_awake_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlutterDisplayAwakePlugin* plugin = FLUTTER_DISPLAY_AWAKE_PLUGIN(
      g_object_new(flutter_display_awake_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_display_awake",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
