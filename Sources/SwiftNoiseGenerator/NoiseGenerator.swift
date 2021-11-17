import Foundation

public protocol NoiseGenerator {

    /// noise (raw)
    ///
    /// - Parameters:
    ///     - x: The *x* component of the vector.
    ///     - y: The *y* component of the vector.
    ///     - z: The *z* component of the vector.
    /// - Returns: noise value (-1.0 ≦ noise ≦ +1.0)
    func noise(_ x: Double, _ y: Double, _ z: Double) -> Double
}

extension NoiseGenerator {

    /// normalized noise
    ///
    /// - Parameters:
    ///     - x: The *x* component of the vector.
    ///     - y: The *y* component of the vector.
    ///     - z: The *z* component of the vector.
    /// - Returns: noise value (0.0 ≦ noise ≦ 1.0)
    public func normalized(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return (noise(x, y, z) + 1) / 2
    }

    /// octave noise
    ///
    /// - Parameters:
    ///     - x: The *x* component of the vector.
    ///     - y: The *y* component of the vector.
    ///     - z: The *z* component of the vector.
    ///     - octaves: (0 < octaves) (e.g. 4)
    ///     - persistence: (0 < persistence < 1) (e.g. 0.5)
    /// - Returns: noise value (0.0 ≦ noise ≦ 1.0)
    public func octaveNoise(_ x: Double, _ y: Double, _ z: Double, octaves: Int, persistence: Double) -> Double {
        var total: Double = 0
        var frequency: Double = 1
        var amplitude: Double = 1
        var maxValue: Double = 0  // Used for normalizing result to 0.0 - 1.0
        for _ in 0 ..< octaves {
            total += normalized(x * frequency, y * frequency, z * frequency) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= 2
        }
        return total / maxValue
    }
}
