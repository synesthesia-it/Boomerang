Pod::Spec.new do |spec|
  spec.name = "RxBoomerangTest"
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

  spec.source_files = "Sources/RxTest/**/*{.swift}"
  spec.dependency "RxBoomerang"
  spec.dependency "RxRelay"
  spec.dependency "RxBlocking"
  spec.dependency "RxSwift"
  spec.framework = "XCTest"

end
