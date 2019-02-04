# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'

def shared_pods
    use_frameworks!
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Action'
end

target 'Boomerang' do
  shared_pods
  platform :ios, '10.0'
  target 'BoomerangTests' do
    inherit! :search_paths
    # Pods for testing
   pod 'Quick'
   pod 'RxBlocking'
   pod 'Nimble'
  end
end

target 'Boomerang-tv' do
    shared_pods
    platform :tvos, '10.0'
end

target 'Demo' do
    platform :ios, '10.0'
    shared_pods
end
target 'DemoTV' do
    shared_pods
    platform :tvos, '10.0'
    
end
