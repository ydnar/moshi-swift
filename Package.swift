// swift-tools-version:6.0
import PackageDescription

// MoshiLib links MLX Swift (Metal), so this package builds only on Apple
// platforms with Apple Silicon. Sources keep their existing flat layout: the
// MoshiLib/ directory, addressed with an explicit `path:`.
//
// Only the MoshiLib library is vended. The Xcode project's MoshiCLI target is
// not a SwiftPM target: it depends on swift-transformers' `Hub`, which that
// package exposes only as an internal target, not as a product a SwiftPM
// manifest can depend on. The CLI remains available through the Xcode project.
let package = Package(
    name: "moshi-swift",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
    ],
    products: [
        .library(name: "MoshiLib", targets: ["MoshiLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift.git", from: "0.21.0"),
    ],
    targets: [
        .target(
            name: "MoshiLib",
            dependencies: [
                .product(name: "MLX", package: "mlx-swift"),
                .product(name: "MLXFast", package: "mlx-swift"),
                .product(name: "MLXNN", package: "mlx-swift"),
                .product(name: "MLXRandom", package: "mlx-swift"),
            ],
            path: "MoshiLib"
        ),
    ]
)
