import Foundation

public struct CellularNoise {
    let v1: Point2D
    let v2: Point2D
    let v: Double

    public init(v1: Point2D, v2: Point2D, v: Double) {
        self.v1 = v1
        self.v2 = v2
        self.v = v
    }

    public init() {
        self.v1 = Point2D(x: 127.1, y: 311.7)
        self.v2 = Point2D(x: 269.5, y: 183.3)
        self.v = 43758.5453
    }
}

extension CellularNoise: NoiseGenerator {

    public func noise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return value(p: Point2D(x: x, y: y), time: z)
    }

    static let SQRT2: Double = sqrt(2)

    func value(p: Point2D, time: Double) -> Double {
        let i_st: Point2D = p.floor // Integer part
        let f_st: Point2D = p.fract // Decimal part
        // From here, find the shortest distance.
        var minDist = Self.SQRT2 // The shortest distance should be less than √2
        // Examine the 3x3 cell
        for j in -1 ... 1 {
            for i in -1 ... 1 {
                // Cell home position
                let neighbor: Point2D = Point2D(x: Double(i), y: Double(j))
                // Points in cell
                let p1: Point2D = random2(p: i_st + neighbor)
                // Animate a point in a cell
                let p2 = ((p1 * (2 * .pi) + time).sin + 1) / 2
                // distance
                let diff: Point2D = (neighbor + p2) - f_st
                minDist = min(minDist, diff.length)
            }
        }
        // Here, minDist should be [0, √2], so normalize it to [0, 1].
        return minDist / Self.SQRT2
    }

    func random2(p: Point2D) -> Point2D {
        return (Point2D(x: p.dot(v1), y: p.dot(v2)).sin * v).fract
    }

    public struct Point2D {
        let x: Double
        let y: Double
    }
}

extension CellularNoise.Point2D {
    func dot(_ v: Self) -> Double { return x*v.x + y*v.y }
    static func * (v: Self, s: Double) -> Self { return Self(x: v.x * s, y: v.y * s) }
    static func + (a: Self, b: Self) -> Self { return Self(x: a.x + b.x, y: a.y + b.y) }
    static func + (v: Self, s: Double) -> Self { return Self(x: v.x + s, y: v.y + s) }
    static func - (a: Self, b: Self) -> Self { return Self(x: a.x - b.x, y: a.y - b.y) }
    static func / (v: Self, s: Double) -> Self { return Self(x: v.x / s, y: v.y / s) }
    var floor: Self { return Self(x: Darwin.floor(x), y: Darwin.floor(y)) }
    var fract: Self { return Self(x: x.fract, y: y.fract) }
    var length: Double { return hypot(x, y) }
    var sin: Self { return Self(x: Darwin.sin(x), y: Darwin.sin(y)) }
}

extension CellularNoise.Point2D: CustomStringConvertible {
    public var description: String { return "(\(x), \(y))" }
}

extension Double {
    var fract: Double { return self - floor(self) }
}
