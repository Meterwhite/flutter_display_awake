import Flutter
import UIKit
import XCTest


@testable import flutter_display_awake

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testKeepScreenOn() {
    let plugin = FlutterDisplayAwakePlugin()

    let call = FlutterMethodCall(methodName: "keepScreenOn", arguments: [])

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertNil(result)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

  func testIsKeptOnReturnsBool() {
    let plugin = FlutterDisplayAwakePlugin()

    let keepOnCall = FlutterMethodCall(methodName: "keepScreenOn", arguments: [])
    plugin.handle(keepOnCall) { _ in }

    let stateCall = FlutterMethodCall(methodName: "isKeptOn", arguments: [])
    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(stateCall) { result in
      XCTAssertNotNil(result as? Bool)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
