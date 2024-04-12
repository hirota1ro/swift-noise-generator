import XCTest
@testable import SwiftNoiseGenerator

final class PerlinNoiseTests: XCTestCase {

    func testPerlinNoise() {
        let perlin = PerlinNoise()
        let noise = perlin.noise(1.0, 2.0, 3.0)
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
