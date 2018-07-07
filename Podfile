# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
target 'nongchung_iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

# Networking Pods
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Kingfisher'
pod 'ObjectMapper'
pod 'AlamofireObjectMapper'

# Google Maps Pods
pod 'GoogleMaps'
pod 'GooglePlaces'

# UI Pods
pod 'SJSegmentedScrollView'

pod 'Cosmos', '~> 16.0'
pod 'YangMingShan'

post_install do |installer| installer.pods_project.build_configurations.each do |config| config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
end
end

  # Pods for nongchung_iOS

  target 'nongchung_iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'nongchung_iOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
