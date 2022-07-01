Pod::Spec.new do |spec|
  spec.name = "Boomerang"
  spec.version = "6.8.0"
  spec.summary = "Swift microframework for MVVM"

  spec.description = <<-DESC
    A Swift microframework helping developers to write better MVVM applications.
                   DESC

  spec.homepage = "http://github.com/synesthesia-it/Boomerang"

  spec.swift_version = "5.1"

  spec.license = "MIT"

  spec.author = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"
  spec.watchos.deployment_target = "6.0"
  spec.tvos.deployment_target = "11.0"

  spec.source = { :git => "https://github.com/synesthesia-it/Boomerang.git", :tag => "#{spec.version}" }

  spec.default_subspec = "Core"

  spec.subspec "Core" do |s|
    s.source_files = "Sources/Core/**/*.{swift}"
    s.weak_framework = "Combine"
    s.weak_framework = "UIKit"
    s.weak_framework = "SwiftUI"
  end

  spec.subspec "RxSwift" do |s|
    s.source_files = "Sources/Rx/**/*{.swift}"
    s.dependency "Boomerang/Core"
    s.dependency "RxCocoa"
    s.dependency "RxSwift"
    s.ios.dependency "RxDataSources"
    s.tvos.dependency "RxDataSources"
    s.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) COCOAPODS_RXBOOMERANG' }
  end 

end
