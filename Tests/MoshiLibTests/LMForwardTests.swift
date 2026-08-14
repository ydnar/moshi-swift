import MLX
import Testing

@testable import MoshiLib

@Suite struct LMForwardTests {
    // Build a tiny, randomly initialized language model and run one forward
    // step. This exercises the temporal transformer, the text embedding, the
    // output norm, and the text head end to end, without needing model weights.
    // It guards the language-model path against build and shape regressions.
    @Test func tinyForwardProducesFiniteLogits() {
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
        let mean = logits.mean().item(Float.self)
        #expect(mean.isFinite)
    }
}
