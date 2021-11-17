import XCTest
@testable import SwiftNoiseGenerator

final class SimplexNoiseTests: XCTestCase {

    func testRawNoise() {
        let simplex = SimplexNoise()
        let noise = simplex.noise(1.0, 2.0, 3.0)
        XCTAssert(-1.0 <= noise && noise <= 1.0)
    }

    func testCoockedNoise() {
        let simplex = SimplexNoise()
        let noise = simplex.normalized(1.0, 2.0, 3.0)
        XCTAssert(0 <= noise && noise <= 1.0)
    }

    func testOctaveNoise() {
        let simplex = SimplexNoise()
        let noise = simplex.octaveNoise(1.0, 2.0, 3.0, octaves: 4, persistence: 0.5)
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
