import XCTest
@testable import SwiftNoiseGenerator

final class CyclicNoiseTests: XCTestCase {

    func testCyclicNoise() {
        let gen = CyclicNoise()
        let noise = gen.noise(1.0, 2.0, 3.0);
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
