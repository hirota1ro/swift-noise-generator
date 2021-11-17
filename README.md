# SwiftNoiseGenerator

This library project contains a few noise generators created in Swift.

## How to use

### Edit your Package.swift

```
     name: "MyExecutable",
     dependencies: [
         // Dependencies declare other packages that this package depends on.
-        // .package(url: /* package url */, from: "1.0.0"),
+        .package(url: "https://github.com/hirota1ro/swift-noise-generator", from: "1.0.0"),
     ],
     targets: [
         // Targets are the basic building blocks of a package. A target can define a module or a test suite.
         // Targets can depend on other targets in this package, and on products in packages this package depends on.
         .executableTarget(
             name: "MyExecutable",
-            dependencies: []),
+            dependencies: [.product(name: "SwiftNoiseGenerator", package: "swift-noise-generator")]),
         .testTarget(
             name: "MyExecutableTests",
             dependencies: ["MyExecutable"]),
```

### Sample Code

```
import SwiftNoiseGenerator

let generator = PerlinNoise()
//let generator = SimplexNoise()

var a: [String] = []
for j in stride(from: 0, to: 360, by: 8) {
    for i in stride(from: 0, to: 480, by: 8) {
        let x = Double(i - 240) / 100
        let y = Double(j - 180) / 100

        let noise = generator.normalized(x, y, 0) // 0〜1
        let b = Int(noise * 255) // 0x00〜0xFF
        let rgb = (b << 16) | (b << 8) | (b) // 0x000000〜0xFFFFFF
        let hex = String(format: "%06x", rgb)

        let s = """
          <rect x="\(i)" y="\(j)" width="8" height="8" fill="#\(hex)" stroke="none" />
          """
        a.append(s)
    }
}

let svg = """
  <svg width="480" height="360" viewBox="0 0 480 360" xmlns="http://www.w3.org/2000/svg" version="1.1">
  \(a.joined(separator: "\n"))
  </svg>
  """
let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
let file = dir.appendingPathComponent("noise.svg")
try! svg.write(to: file, atomically: true, encoding: .utf8)
```
