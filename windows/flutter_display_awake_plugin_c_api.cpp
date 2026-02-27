#include "include/flutter_display_awake/flutter_display_awake_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_display_awake_plugin.h"

void FlutterDisplayAwakePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_display_awake::FlutterDisplayAwakePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
