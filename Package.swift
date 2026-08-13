// swift-tools-version:6.0
import PackageDescription

// A pure SwiftPM package. MoshiLib links MLX Swift (Metal), so it builds only on
// Apple platforms with Apple Silicon.
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
            ]
        ),
    ]
)
