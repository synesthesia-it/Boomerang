// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Boomerang",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "Boomerang", targets: ["Boomerang"]),
//        .library(name: "Boomerang", targets: ["Boomerang-watch"]),
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/RxSwiftCommunity/Action", from: "3.10.0"),
        .package(url: "https://github.com/RxSwift/RxSwift", from: "4.4.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Boomerang",
            dependencies: ["RxSwift","RxCocoa","Action"],
            path:"Sources"),
//        .target(
//            name: "Boomerang-watch",
//            dependencies: ["RxSwift","RxCocoa","RxAtomic","Action"],
//            path:"Sources"),
        .testTarget(
            name: "BoomerangTests",
            dependencies: ["Boomerang","RxSwift","RxCocoa","Action"],
            path:"Tests")
    ]
)
