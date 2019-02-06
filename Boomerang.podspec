
Pod::Spec.new do |s|

  s.name         = "Boomerang"
  s.version      = "5.0.0"
  s.summary      = "Swift microframework for MVVM"
  s.description  = <<-DESC
  Boomerang is a swift microframework for better crossplatform apps
                   DESC

  s.homepage     = "https://github.com/synesthesia-it/Boomerang"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }

  s.ios.deployment_target = "10.0"
  # s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/stefanomondino/Boomerang.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/{.,Model,View/Shared,ViewModel}/*.{swift}"
  s.ios.source_files = "Sources/View/UIKit/**/*.{swift}"
  s.tvos.source_files = "Sources/View/UIKit/**/*.{swift}"
  s.watchos.source_files = "Sources/View/WatchOS/**/*.{swift}"

  s.dependency "RxSwift", "~> 4.4"
  s.dependency "Action"
end
