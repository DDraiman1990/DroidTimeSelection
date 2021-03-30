#
# Be sure to run `pod lib lint DroidTimeSelection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DroidTimeSelection'
  s.version          = '2.0.1'
  s.summary          = 'The Android Time Selector for iOS.'

  s.description      = <<-DESC
  As someone who used Android for a long time, I found I really missed selecting time using the Android selector. So, I brought it to iOS and mixed it with the manual selection of the UIDatePicker, native to iOS. Now we can enjoy the best of both worlds :D
                       DESC

  s.homepage         = 'https://github.com/DDraiman1990/DroidTimeSelection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DDraiman1990' => 'ddraiman1990@gmail.com' }
  s.source           = { :git => 'https://github.com/DDraiman1990/DroidTimeSelection.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'DroidTimeSelection/Classes/**/*'
  s.exclude_files = "DroidTimeSelection/**/*.plist"
  s.resources = 'DroidTimeSelection/Assets/*.xcassets'
  s.swift_version = '5.0'

  s.frameworks = 'UIKit'
end
