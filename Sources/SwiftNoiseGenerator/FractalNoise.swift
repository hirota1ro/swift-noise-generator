import Foundation

public struct FractalNoise {
    // Decorator pattern
    let original: NoiseGenerator

    // Properties
    let octaves: Int
    let lacunarity: Double
    let gain: Double

    public init(original: NoiseGenerator, octaves: Int = 8, lacunarity: Double = 2, gain: Double = 0.5) {
        self.original = original
        self.octaves = octaves
        self.lacunarity = lacunarity
        self.gain = gain
    }
}

extension FractalNoise: NoiseGenerator {

    public func noise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        // Initial values
        var value: Double = 0.0
        var maxValue: Double = 0.0
        var amplitude: Double = 1.0
        var frequency: Double = 1.0

        // Loop of octaves
        for _ in 0 ..< octaves {
	    value += original.noise(x * frequency, y * frequency, z * frequency) * amplitude
            maxValue += amplitude
	    amplitude *= gain
	    frequency *= lacunarity
        }
        return value / maxValue
    }
}
