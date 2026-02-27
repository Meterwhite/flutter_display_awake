#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_display_awake.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_display_awake'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin to keep the screen awake and restore default sleep behavior.'
  s.description      = <<-DESC
A Flutter plugin to keep the screen awake and restore default sleep behavior.
                       DESC
  s.homepage         = 'https://pub.dev/packages/flutter_display_awake'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  # If your plugin requires a privacy manifest, for example if it collects user
  # data, update the PrivacyInfo.xcprivacy file to describe your plugin's
  # privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_display_awake_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
