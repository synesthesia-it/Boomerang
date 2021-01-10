Pod::Spec.new do |spec|

  spec.name         = "Boomerang"
  spec.version      = "6.2.2"
  spec.summary      = "Swift microframework for MVVM"

  spec.description  = <<-DESC
    A Swift microframework helping developers to write better MVVM applications.
                   DESC

  spec.homepage     = "http://github.com/synesthesia-it/Boomerang"

  spec.swift_version = '5.1'

  spec.license      = "MIT"

  spec.author             = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }

  spec.ios.deployment_target = "11.0"
#  spec.osx.deployment_target = "10.13"
#  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "11.0"

  spec.source       = { :git => "https://github.com/synesthesia-it/Boomerang.git", :tag => "#{spec.version}" }

  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |s|
    s.source_files = "Sources/Core/**/*.{swift}"
    s.weak_framework = "Combine"
    s.weak_framework = "UIKit"
    s.weak_framework = "SwiftUI"
  end

#  spec.subspec 'UIKit' do |s|
#    s.source_files = "Sources/UIKit/**/*{.swift}"
#    s.dependency "Boomerang/Core"
#    s.framework = "UIKit"
#    s.ios.deployment_target = "11.0"
#    s.tvos.deployment_target = "11.0"
#  end

  spec.subspec 'RxSwift' do |s|
    s.source_files = "Sources/Rx/**/*{.swift}"
    s.dependency "Boomerang/Core"
    s.dependency "RxCocoa"
    s.dependency "RxSwift"
    s.dependency "RxDataSources"
  end
# Currently, cocoapods doesn't support mixed deployment targets between subspecs.

#  spec.subspec 'Combine' do |s|
#    s.source_files = "Sources/Combine/**/*{.swift}"
#    s.dependency "Boomerang/Core"
#    s.framework = "Combine"
#    s.framework = "SwiftUI"
#    s.ios.deployment_target = "13.0"
#    s.tvos.deployment_target = "13.0"
#    s.watchos.deployment_target = "6.0"
#  end
#
#  spec.subspec 'SwiftUI' do |s|
#    s.source_files = "Sources/Combine/**/*{.swift}"
#    s.dependency "Boomerang/Combine"
#    s.ios.deployment_target = "13.0"
#    s.tvos.deployment_target = "13.0"
#    s.watchos.deployment_target = "6.0"
#    s.framework = "Combine"
#    s.framework = "SwiftUI"
#  end

end
