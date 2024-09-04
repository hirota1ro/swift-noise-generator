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
        guard let ctx = CGContext(data: nil,
                                  width: Int(ceil(size.width)),
                                  height: Int(ceil(size.height)),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 4 * Int(ceil(size.width)),
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            fatalError("CGContext.init()")
        }
        for y in stride(from: 0, to: size.height, by: 1) {
            for x in stride(from: 0, to: size.width, by: 1) {
                let brightness = gen.noise(x * 0.05, y * 0.05, 0)
                ctx.setFillColor(CGColor(gray: brightness, alpha: 1))
                ctx.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
        guard let image = ctx.makeImage() else { fatalError("CGContext.makeImage()") }
        let data = image.pngData
        do {
            try data.write(to: fileURL, options: .atomic)
            print("succeeded to write \(fileURL.path)")
        } catch {
            print("failed to write \(error)")
        }
    }
}

extension CGImage {
    var pngData: Data {
        let bitmapRep = NSBitmapImageRep(cgImage: self)
        guard let data = bitmapRep.representation(using: .png, properties: [:]) else {
            fatalError("no data")
        }
        return data
    }
}

extension URL {
    static func + (dir: URL, name: String) -> URL { return dir.appendingPathComponent(name) }
}
