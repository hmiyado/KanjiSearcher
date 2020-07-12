# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

rx_version = "5.1.1"

target 'KanjiSearcher' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KanjiSearcher
  pod 'RxSwift', "~>#{rx_version}"
  pod 'RxCocoa', "~>#{rx_version}"

  target 'KanjiSearcherTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', "~>#{rx_version}"
    pod 'RxTest', "~>#{rx_version}"
  end

end
