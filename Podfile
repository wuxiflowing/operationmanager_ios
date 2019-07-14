platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!
target 'OperationsManager' do
    pod 'AFNetworking'
    pod 'Masonry'
    pod 'MJRefresh'
    pod 'YYWebImage'
    pod 'MBProgressHUD'
    pod 'Bugly'
    pod 'SDCycleScrollView'
    pod 'MJExtension'
    pod 'BaiduMapKit','~>4.0.0'
    pod 'SDAutoLayout','~>2.2.1'
    pod 'IQKeyboardManager','~>6.1.1'
    
end
#消除pod target 版本警告
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
