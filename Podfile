# Uncomment the next line to define a global platform for your project

def shared_pods
    use_frameworks!
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Action'
end

target 'Boomerang' do
  platform :ios, '10.0'
  shared_pods
  target 'BoomerangTests' do
    inherit! :search_paths
    # Pods for testing
   pod 'Quick'
   pod 'RxBlocking'
   pod 'Nimble'
  end
end

target 'Boomerang-tv' do
    platform :tvos, '10.0'
    shared_pods
end

target 'Boomerang-watch' do
    platform :watchos, '4.0'
    shared_pods
end

target 'Demo' do
    platform :ios, '10.0'
    shared_pods
end
target 'DemoTV' do
    platform :tvos, '10.0'
    pod 'ParallaxView'
    shared_pods
end
target 'DemoWatch' do
    platform :watchos, '3.0'
    shared_pods
end

target 'DemoWatch Extension' do
    platform :watchos, '3.0'
    shared_pods
end
