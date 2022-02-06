// swift-tools-version:5.5

import PackageDescription

// MARK: - Names

extension String {
    static let DecimalField = "DecimalField"
    static let Tests = "Tests"
}

// MARK: - Package

let package = Package(
    name: .DecimalField,
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .decimalFieldLibrary
    ],
    targets: [
        .decimalField,
        .decimalFieldTests
    ]
)

// MARK: - Products

extension Product {
    static let decimalFieldLibrary: Product = .library(
        name: .DecimalField,
        targets: [
            Target.decimalField.name
        ]
    )
}

// MARK: - Targets

extension Target {
    static let decimalField: Target = .target(
        name: .DecimalField,
        dependencies: []
    )

    static let decimalFieldTests: Target = .testTarget(
        name: .DecimalField + .Tests,
        dependencies: [
            .decimalField
        ]
    )
}

// MARK: - Target Dependencies

extension Target.Dependency {
    static let decimalField: Target.Dependency = .target(
        name: .DecimalField,
        condition: .when(
            platforms: [.iOS]
        )
    )
}
