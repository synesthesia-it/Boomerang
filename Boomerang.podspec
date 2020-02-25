Pod::Spec.new do |spec|

  spec.name         = "Boomerang"
  spec.version      = "6.0"
  spec.summary      = "Quick MVVM on steroids"

  spec.description  = <<-DESC
    A Swift microframework helping developers to write better MVVM applications.
                   DESC

  spec.homepage     = "http://github.com/synesthesia-it/Boomerang"


  spec.license      = "MIT"

  spec.author             = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"
  spec.watchos.deployment_target = "4.0"
  spec.tvos.deployment_target = "11.0"

  spec.source       = { :git => "https://github.com/synesthesia-it/Boomerang.git", :tag => "#{spec.version}" }

  spec.default_subspec = 'UIKit'

  spec.subspec 'Core' do |s|
    s.source_files = "Sources/Core/**/*.{swift}"
  end

  spec.subspec 'UIKit' do |s|
    s.source_files = "Sources/UIKit/**/*{.swift}"
    s.dependency "Boomerang/Core"
    s.framework = "UIKit"
  end

  spec.subspec 'RxSwift' do |s|
    s.source_files = "Sources/Rx/**/*{.swift}"
    s.dependency "Boomerang/UIKit"
    s.dependency "RxCocoa"
    s.dependency "RxSwift"
    s.dependency "RxDataSources"
  end

  spec.subspec 'Combine' do |s|
    s.source_files = "Sources/Combine/**/*{.swift}"
    s.dependency "Boomerang/Core"
    s.ios.deployment_target = "13.0"
    s.framework = "Combine"
    s.framework = "SwiftUI"
  end
  
  spec.subspec 'SwiftUI' do |s|
    s.source_files = "Sources/Combine/**/*{.swift}"
    s.dependency "Boomerang/Combine"
    s.ios.deployment_target = "13.0"
    s.framework = "Combine"
    s.framework = "SwiftUI"
  end

end
