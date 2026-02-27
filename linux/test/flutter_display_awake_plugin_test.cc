#include <flutter_linux/flutter_linux.h>
#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "include/flutter_display_awake/flutter_display_awake_plugin.h"
#include "flutter_display_awake_plugin_private.h"

// This demonstrates a simple unit test of the C portion of this plugin's
// implementation.
//
// Once you have built the plugin's example app, you can run these tests
// from the command line. For instance, for a plugin called my_plugin
// built for x64 debug, run:
// $ build/linux/x64/debug/plugins/my_plugin/my_plugin_test

namespace flutter_display_awake {
namespace test {

TEST(FlutterDisplayAwakePlugin, KeepScreenOnReturnsSuccess) {
  FlutterDisplayAwakePlugin* plugin = flutter_display_awake_plugin_new_for_test();
  ASSERT_NE(plugin, nullptr);

  g_autoptr(FlMethodResponse) response = keep_screen_on(plugin);
  ASSERT_NE(response, nullptr);
  ASSERT_TRUE(FL_IS_METHOD_SUCCESS_RESPONSE(response));

  flutter_display_awake_plugin_free_for_test(plugin);
}

TEST(FlutterDisplayAwakePlugin, KeepScreenOffReturnsSuccess) {
  FlutterDisplayAwakePlugin* plugin = flutter_display_awake_plugin_new_for_test();
  ASSERT_NE(plugin, nullptr);

  g_autoptr(FlMethodResponse) response = keep_screen_off(plugin);
  ASSERT_NE(response, nullptr);
  ASSERT_TRUE(FL_IS_METHOD_SUCCESS_RESPONSE(response));

  flutter_display_awake_plugin_free_for_test(plugin);
}

TEST(FlutterDisplayAwakePlugin, IsKeptOnReturnsBool) {
  FlutterDisplayAwakePlugin* plugin = flutter_display_awake_plugin_new_for_test();
  ASSERT_NE(plugin, nullptr);

  g_autoptr(FlMethodResponse) response = is_kept_on(plugin);
  ASSERT_NE(response, nullptr);
  ASSERT_TRUE(FL_IS_METHOD_SUCCESS_RESPONSE(response));

  FlValue* result =
      fl_method_success_response_get_result(FL_METHOD_SUCCESS_RESPONSE(response));
  ASSERT_NE(result, nullptr);
  ASSERT_EQ(fl_value_get_type(result), FL_VALUE_TYPE_BOOL);

  flutter_display_awake_plugin_free_for_test(plugin);
}

}  // namespace test
}  // namespace flutter_display_awake
