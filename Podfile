platform :ios, '12.0'

inhibit_all_warnings!

target 'EasyLeague' do
  use_frameworks!

  # Pods for EasyLeague
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'FirebaseStorageSwift', '8.14.0-beta'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '8.13.0-beta'
  pod 'CropViewController'
  pod 'Kingfisher'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
