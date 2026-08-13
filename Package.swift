// swift-tools-version:6.0
import PackageDescription

// MoshiLib and its CLI link MLX Swift (Metal), so this package builds only on
// Apple platforms with Apple Silicon. Sources keep their existing flat layout:
// the MoshiLib/ and MoshiCLI/ directories, addressed with explicit `path:`.
let package = Package(
    name: "moshi-swift",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
    ],
    products: [
        .library(name: "MoshiLib", targets: ["MoshiLib"]),
        .executable(name: "moshi-cli", targets: ["MoshiCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift.git", from: "0.21.0"),
        .package(url: "https://github.com/huggingface/swift-transformers", from: "0.1.14"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "MoshiLib",
            dependencies: [
                .product(name: "MLX", package: "mlx-swift"),
                .product(name: "MLXFast", package: "mlx-swift"),
                .product(name: "MLXNN", package: "mlx-swift"),
                .product(name: "MLXRandom", package: "mlx-swift"),
                .product(name: "Hub", package: "swift-transformers"),
            ],
            path: "MoshiLib"
        ),
        .executableTarget(
            name: "MoshiCLI",
            dependencies: [
                "MoshiLib",
                .product(name: "MLX", package: "mlx-swift"),
                .product(name: "MLXNN", package: "mlx-swift"),
                .product(name: "Hub", package: "swift-transformers"),
                .product(name: "Tokenizers", package: "swift-transformers"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "MoshiCLI"
        ),
    ]
)
