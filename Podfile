source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '16.0'

project 'Code/LiveActionBetrayal.xcodeproj'

use_frameworks!

target :LiveActionBetrayal do
  pod 'PinkyPromise'
  pod 'ReSwift'
  pod 'FirebaseCore'
	pod 'FirebaseAuth'
	pod 'FirebaseDatabase'
	pod 'FirebaseStorage'
  pod 'FirebaseFunctions'
  pod 'JSQMessagesViewController'
  pod 'Nuke'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
