// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Boomerang",
    platforms: [
        .iOS(.v11), .tvOS(.v11), .watchOS(.v6), .macOS(.v10_15)
    ],

    products: [
        .library(name: "Boomerang", targets: ["Boomerang"]),
        .library(name: "RxBoomerang", targets: ["RxBoomerang"]),
        .library(name: "RxBoomerangTest", targets: ["RxBoomerangTest"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "Boomerang",
            dependencies: [],
            path: "Sources/Core",
            linkerSettings: [.linkedFramework("UIKit",
                                              .when(platforms: [.iOS, .tvOS]))]),
            .testTarget(name: "BoomerangTests",
                    dependencies: ["Boomerang"]),
        .target(
            name: "RxBoomerang",
            dependencies: [ "Boomerang",
                            .product(name: "RxSwift", package: "RxSwift"),
                            .product(name: "RxCocoa", package: "RxSwift"),
                            "RxDataSources"],
            path: "Sources/Rx",
            linkerSettings: [.linkedFramework("RxDataSources", .when(platforms: [.iOS, .tvOS]))]),
    
        .target(
            name: "RxBoomerangTest",
            dependencies: [ "RxBoomerang",
                            .product(name: "RxBlocking", package: "RxSwift")
                            ],
            path: "Sources/RxTest")
    ],
    swiftLanguageVersions: [.v5]
)
