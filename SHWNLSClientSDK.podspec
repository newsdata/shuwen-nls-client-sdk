#
# Be sure to run `pod lib lint SHWAccountSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SHWNLSClientSDK'
  s.version          = '0.2.0'
  s.summary          = '英文版语音服务 SDK.'
  s.homepage         = 'https://code.aliyun.com/xhzy-ios/SHWNLSClientSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangyang' => 'yangyang@shuwen.com' }
  s.source           = { :git => 'https://code.aliyun.com/xhzy-ios/SHWNLSClientSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.vendored_framework = "SHWNLSClientSDK/Classes/SHWNLSClient.framework"
  s.requires_arc = true
  s.frameworks = 'SystemConfiguration', 'AudioToolbox', 'AVFoundation'
end
