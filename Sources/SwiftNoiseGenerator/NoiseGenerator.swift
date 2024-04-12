import Foundation

public protocol NoiseGenerator {

    /// obtain noise value at point
    ///
    /// - Parameters:
    ///     - x: The *x* component of the point.
    ///     - y: The *y* component of the point.
    ///     - z: The *z* component of the point.
    /// - Returns: noise value (0.0 ≦ noise ≦ 1.0)
    func noise(_ x: Double, _ y: Double, _ z: Double) -> Double
}
