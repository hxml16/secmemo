platform :ios, '12.2'

target 'secmemo' do
  use_frameworks!
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxKeyboard'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'SwiftLint'
  pod 'SwiftKeychainWrapper'
  pod 'RxCoreLocation', '~> 1.5.1'
  pod 'RxPermission/Camera'
  pod 'RxPermission/Photos'

  target 'secmemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'secmemoUITests' do
    # Pods for testing
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.2'
        end
    end
end
