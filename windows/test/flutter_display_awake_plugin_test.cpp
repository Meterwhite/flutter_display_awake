#include <flutter/method_call.h>
#include <flutter/method_result_functions.h>
#include <flutter/standard_method_codec.h>
#include <gtest/gtest.h>
#include <windows.h>

#include <memory>
#include <string>
#include <variant>

#include "flutter_display_awake_plugin.h"

namespace flutter_display_awake {
namespace test {

namespace {

using flutter::EncodableValue;
using flutter::MethodCall;
using flutter::MethodResultFunctions;

}  // namespace

TEST(FlutterDisplayAwakePlugin, KeepScreenOnAndOffAndState) {
  FlutterDisplayAwakePlugin plugin;

  bool keep_screen_on_called = false;
  plugin.HandleMethodCall(
      MethodCall("keepScreenOn", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&keep_screen_on_called](const EncodableValue* result) {
            keep_screen_on_called = true;
            EXPECT_EQ(result, nullptr);
          },
          nullptr, nullptr));
  EXPECT_TRUE(keep_screen_on_called);

  bool state_query_called = false;
  bool is_kept_on = false;
  plugin.HandleMethodCall(
      MethodCall("isKeptOn", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&state_query_called, &is_kept_on](const EncodableValue* result) {
            state_query_called = true;
            ASSERT_NE(result, nullptr);
            is_kept_on = std::get<bool>(*result);
          },
          nullptr, nullptr));
  EXPECT_TRUE(state_query_called);
  EXPECT_TRUE(is_kept_on);

  bool keep_screen_off_called = false;
  plugin.HandleMethodCall(
      MethodCall("keepScreenOff", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&keep_screen_off_called](const EncodableValue* result) {
            keep_screen_off_called = true;
            EXPECT_EQ(result, nullptr);
          },
          nullptr, nullptr));
  EXPECT_TRUE(keep_screen_off_called);

  state_query_called = false;
  is_kept_on = true;
  plugin.HandleMethodCall(
      MethodCall("isKeptOn", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          [&state_query_called, &is_kept_on](const EncodableValue* result) {
            state_query_called = true;
            ASSERT_NE(result, nullptr);
            is_kept_on = std::get<bool>(*result);
          },
          nullptr, nullptr));
  EXPECT_TRUE(state_query_called);
  EXPECT_FALSE(is_kept_on);
}

TEST(FlutterDisplayAwakePlugin, UnknownMethodNotImplemented) {
  FlutterDisplayAwakePlugin plugin;

  bool not_implemented_called = false;
  plugin.HandleMethodCall(
      MethodCall("unknownMethod", std::make_unique<EncodableValue>()),
      std::make_unique<MethodResultFunctions<>>(
          nullptr,
          nullptr,
          [&not_implemented_called]() { not_implemented_called = true; }));

  EXPECT_TRUE(not_implemented_called);
}

}  // namespace test
}  // namespace flutter_display_awake
