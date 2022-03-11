platform :ios, '12.0'

target 'EasyLeague' do
  use_frameworks!

  # Pods for EasyLeague
  pod 'Firebase/Auth'

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
