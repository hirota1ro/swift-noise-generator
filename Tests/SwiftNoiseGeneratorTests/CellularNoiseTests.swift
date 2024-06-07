import XCTest
@testable import SwiftNoiseGenerator

final class CellularNoiseTests: XCTestCase {

    func testCellularNoise() {
        let gen = CellularNoise()
        let noise = gen.noise(1.0, 2.0, 3.0);
        XCTAssert(0 <= noise && noise <= 1.0)
    }
}
