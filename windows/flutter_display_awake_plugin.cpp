#include "flutter_display_awake_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

namespace flutter_display_awake {

// static
void FlutterDisplayAwakePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_display_awake",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterDisplayAwakePlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FlutterDisplayAwakePlugin::FlutterDisplayAwakePlugin() {}

FlutterDisplayAwakePlugin::~FlutterDisplayAwakePlugin() {
  if (keep_screen_on_) {
    SetThreadExecutionState(ES_CONTINUOUS);
  }
}

void FlutterDisplayAwakePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("keepScreenOn") == 0) {
    SetThreadExecutionState(ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED);
    keep_screen_on_ = true;
    result->Success();
  } else if (method_call.method_name().compare("keepScreenOff") == 0) {
    SetThreadExecutionState(ES_CONTINUOUS);
    keep_screen_on_ = false;
    result->Success();
  } else if (method_call.method_name().compare("isKeptOn") == 0) {
    result->Success(flutter::EncodableValue(keep_screen_on_));
  } else {
    result->NotImplemented();
  }
}

}  // namespace flutter_display_awake
