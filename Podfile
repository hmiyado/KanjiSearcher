# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

rx_version = "5.1.1"

target 'KanjiSearcher' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KanjiSearcher
  pod 'Alamofire', '~> 5.2'
  
  pod 'RxAlamofire', '~> 5.6.0'
  pod 'RxSwift', "~>#{rx_version}"
  pod 'RxCocoa', "~>#{rx_version}"

  pod 'SwiftLint', "~>0.39.2"

  target 'KanjiSearcherTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', "~>#{rx_version}"
    pod 'RxTest', "~>#{rx_version}"
    
    pod 'Quick', '~>3.0.0'
    pod 'Nimble', '~>8.1.1'

  end

end
