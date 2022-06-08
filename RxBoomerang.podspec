Pod::Spec.new do |spec|
  spec.name = "RxBoomerang"
  spec.version = "6.7.0"
  spec.summary = "RxSwift extensions for Boomerang"

  spec.description = <<-DESC
    RxSwift extensions for Boomerang - a Swift microframework helping developers to write better MVVM applications.
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

  spec.source_files = "Sources/Rx/**/*{.swift}"
  spec.dependency "Boomerang/Core"
  spec.dependency "RxCocoa"
  spec.dependency "RxSwift"
  spec.ios.dependency "RxDataSources"
  spec.tvos.dependency "RxDataSources"
end
