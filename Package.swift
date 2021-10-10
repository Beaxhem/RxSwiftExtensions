// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RxSwiftExtensions",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "RxSwiftExtensions",
            targets: ["RxSwiftExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.2.0"))
    ],
    targets: [
        .target(
            name: "RxSwiftExtensions",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ]),
        .testTarget(
            name: "RxSwiftExtensionsTests",
            dependencies: [
                "RxSwiftExtensions",
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
    ]
)
