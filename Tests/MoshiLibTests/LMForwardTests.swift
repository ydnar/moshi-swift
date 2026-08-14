import Foundation
import MLX
import Testing

@testable import MoshiLib

@Suite struct LMForwardTests {
    // Config construction is pure Swift with no MLX compute, so it runs
    // everywhere, including CI. It guards the moshika config against drift.
    @Test func moshikaConfigHasExpectedShape() {
        let cfg = LmConfig.moshi_2024_07()
        #expect(cfg.transformer.dModel == 4096)
        #expect(cfg.transformer.numLayers == 32)
        #expect(cfg.textOutVocabSize == 32000)
        #expect(cfg.audioCodebooks == 16)
    }

    // A forward pass runs MLX compute, which needs a Metal GPU. GitHub-hosted
    // runners do not provide one, so loading the Metal library fails there. This
    // test is skipped under CI and runs on a developer machine with a GPU. It
    // still compiles in CI, so it guards the language-model path against API
    // drift. It builds a tiny, randomly initialized LM and runs one forward
    // step, checking the logits shape and finiteness, without model weights.
    @Test(.enabled(if: ProcessInfo.processInfo.environment["CI"] == nil))
    func tinyForwardProducesFiniteLogits() {
        let transformer = TransformerConfig(
            dModel: 32,
            numHeads: 4,
            numLayers: 2,
            causal: true,
            normFirst: true,
            biasFF: false,
            biasAttn: false,
            layerScale: nil,
            positionalEmbedding: .rope,
            useConvBias: false,
            gating: true,
            norm: .rmsNorm,
            context: 64,
            maxPeriod: 10000,
            maxSeqLen: 128,
            kvRepeat: 1,
            dimFeedForward: 128,
            convLayout: false,
            useRotatingKVCache: false
        )
        let cfg = LmConfig(
            transformer: transformer,
            depformer: nil,
            textInVocabSize: 48,
            textOutVocabSize: 32,
            audioVocabSize: 4,
            audioCodebooks: 0,
            audioDelays: []
        )
        let lm = LM(cfg, bSize: 1)
        let tokens = MLXArray([Int32(0)]).reshaped([1, 1])

        let logits = lm(tokens)

        #expect(logits.shape == [1, 1, cfg.textOutVocabSize])
        #expect(logits.mean().item(Float.self).isFinite)
    }
}
