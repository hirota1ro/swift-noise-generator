import XCTest
@testable import SwiftNoiseGenerator

final class SimplexNoiseTests: XCTestCase {

    func testSimplexNoise() {
        let simplex = SimplexNoise()
        let noise = simplex.noise(1.0, 2.0, 3.0)
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
