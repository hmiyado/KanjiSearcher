# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

rx_version = "5.1.1"

target 'KanjiSearcher' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KanjiSearcher
  pod 'Alamofire', '~> 5.2'
  
  pod 'SnapKit', '~> 5.0.0'
  pod 'RxAlamofire', '~> 5.6.0'
  pod 'RxSwift', "~>#{rx_version}"
  pod 'RxCocoa', "~>#{rx_version}"

  pod 'SwiftLint', "~>0.39.2"
  pod 'LicensePlist'

  target 'KanjiSearcherTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', "~>#{rx_version}"
    pod 'RxTest', "~>#{rx_version}"
    
    pod 'OHHTTPStubs/Swift', '~>9.0.0'
    pod 'Quick', '~>3.0.0'
    pod 'Nimble', '~>8.1.1'

  end

end
