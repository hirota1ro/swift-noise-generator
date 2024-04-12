import XCTest
@testable import SwiftNoiseGenerator

final class FractalNoiseTests: XCTestCase {

    func testFractalNoise() {
        let gen = FractalNoise(original: PerlinNoise())
        let noise = gen.noise(1.0, 2.0, 3.0);
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
