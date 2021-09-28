// swift-tools-version:5.3
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsAdvanced
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSProtocolsAdvanced",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSProtocolsAdvanced",
            type: .static,
            targets: ["DNSProtocolsAdvanced"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.2"),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", from: "1.6.0"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "1.6.0"),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", from: "1.6.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSProtocolsAdvanced",
            dependencies: ["Alamofire", "DNSCoreThreading", "DNSError", "DNSProtocols"]),
        .testTarget(
            name: "DNSProtocolsAdvancedTests",
            dependencies: ["DNSProtocolsAdvanced"]),
    ],
    swiftLanguageVersions: [.v5]
)
