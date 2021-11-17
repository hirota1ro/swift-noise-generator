import XCTest
@testable import SwiftNoiseGenerator

final class PerlinNoiseTests: XCTestCase {

    func testRawNoise() {
        let perlin = PerlinNoise()
        let noise = perlin.noise(1.0, 2.0, 3.0)
        XCTAssert(-1.0 <= noise && noise <= 1.0)
    }

    func testCoockedNoise() {
        let perlin = PerlinNoise()
        let noise = perlin.normalized(1.0, 2.0, 3.0)
        XCTAssert(0 <= noise && noise <= 1.0)
    }

    func testOctaveNoise() {
        let perlin = PerlinNoise()
        let noise = perlin.octaveNoise(1.0, 2.0, 3.0, octaves: 4, persistence: 0.5)
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
