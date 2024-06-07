import XCTest
import Cocoa
import CoreGraphics
@testable import SwiftNoiseGenerator

final class CreateImageTests: XCTestCase {

    func _testCreateFractalNoiseImage_() {
        let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

        createImage(fileURL: dir + "perlinNoise.png", gen: PerlinNoise())
        createImage(fileURL: dir + "simplexNoise.png", gen: SimplexNoise())
        createImage(fileURL: dir + "fractalNoise.png", gen: FractalNoise(original: PerlinNoise()))
        createImage(fileURL: dir + "cyclicNoise.png", gen: CyclicNoise())
        createImage(fileURL: dir + "cellularNoise.png", gen: CellularNoise())
    }

    private func createImage(fileURL: URL, gen: NoiseGenerator) {
        let size = CGSize(width: 128, height: 128)
        let image = NSImage(size: size)
        image.lockFocus()
        for y in stride(from: 0, to: size.height, by: 1) {
            for x in stride(from: 0, to: size.width, by: 1) {
                let brightness = gen.noise(x * 0.05, y * 0.05, 0)
                NSColor(white: brightness, alpha: 1).setFill()
                CGRect(x: x, y: y, width: 1, height: 1).fill()
            }
        }
        image.unlockFocus()
        guard let data = image.pngData else { fatalError() }
        do {
            try data.write(to: fileURL, options: .atomic)
            print("succeeded to write \(fileURL.path)")
        } catch {
            print("failed to write \(error)")
        }
    }
}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = self.tiffRepresentation else {
            print("no tiffRep")
            return nil
        }
        guard let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            print("no bitmapImageRep")
            return nil
        }
        guard let data = bitmapImage.representation(using: .png, properties: [:]) else {
            print("no data")
            return nil
        }
        return data
    }
}

extension URL {
    static func + (dir: URL, name: String) -> URL { return dir.appendingPathComponent(name) }
}
