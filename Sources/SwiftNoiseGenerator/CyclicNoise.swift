import Foundation

public struct CyclicNoise {

    let octaves: Int
    let lacunarity: Double
    let gain: Double

    let warp: Double
    let warpGain: Double

    let rotMatrix: mat3

    public init(octaves: Int = 8, lacunarity: Double = 1.5, gain: Double = 0.6, warp: Double = 0.3, warpGain: Double = 1.5) {
        self.octaves = octaves
        self.lacunarity = lacunarity
        self.gain = gain
        self.warp = warp
        self.warpGain = warpGain

        let seed = vec3(-1, -2.0, 0.5)
        self.rotMatrix = CyclicNoise.getOrthogonalBasis(seed)
    }
}

extension CyclicNoise {

    static func getOrthogonalBasis(_ dir: vec3) -> mat3 {
        let direction = normalize(dir)
        let right: vec3 = normalize(cross(vec3(0, 1, 0), direction))
        let up: vec3 = normalize(cross(direction, right))
        return mat3(right, up, direction)
    }
}

extension CyclicNoise: NoiseGenerator {

    /// - Returns: noise value [0, 1]
    public func noise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return (cyclicNoise(x, y, z) + 1) / 2
    }

    /// - Returns: noise value [-1, +1]
    func cyclicNoise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        var p = vec3(x, y, z)
        var amp: Double = 1.0
        var value: Double = 0.0
        var maxValue: Double = 0.0
        var warpTrk: Double = 1.2
        for _ in 0 ..< octaves {
            p += sin(p.zxy * warpTrk - 2 * warpTrk) * warp
            value += sin(dot(cos(p), sin(p.zxy))) * amp
            maxValue += amp
            p *= rotMatrix
            p *= lacunarity
            warpTrk *= warpGain
            amp *= gain
        }
        return value / maxValue
    }
}

extension CyclicNoise {

    struct vec3 {
        let x: Double
        let y: Double
        let z: Double
    }

    struct mat3 {
        let a00: Double
        let a01: Double
        let a02: Double
        let a10: Double
        let a11: Double
        let a12: Double
        let a20: Double
        let a21: Double
        let a22: Double
    }
}

extension CyclicNoise.vec3 {

    init(_ x: Double = 0, _ y: Double = 0, _ z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    func dot(_ v: Self) -> Double { return x * v.x + y * v.y + z * v.z }
    func cross(_ v: Self) -> Self { return Self(y * v.z - v.y * z, z * v.x - v.z * x, x * v.y - v.x * y) }
    func mul(_ s: Double) -> Self { return Self(x * s, y * s, z * s) }
    func minus(_ s: Double) -> Self { return Self(x - s, y - s, z - s) }
    func plus(_ v: Self) -> Self { return Self(x + v.x, y + v.y, z + v.z) }
    var zxy: Self { return Self(z, x, y) }
    var length: Double { return sqrt(x*x + y*y + z*z) }
    var normalized: Self {
        let l = self.length
        if l == 0 { return Self() }
        return Self(x/l, y/l, z/l)
    }
}

extension CyclicNoise.mat3 {

    init(_ a: CyclicNoise.vec3, _ b: CyclicNoise.vec3, _ c: CyclicNoise.vec3) {
        self.a00 = a.x
        self.a01 = a.y
        self.a02 = a.z
        self.a10 = b.x
        self.a11 = b.y
        self.a12 = b.z
        self.a20 = c.x
        self.a21 = c.y
        self.a22 = c.z
    }

    /// - Returns: v × self
    func preMul(_ v: CyclicNoise.vec3) -> CyclicNoise.vec3 {
        let x = v.x * a00 + v.y * a10 + v.z * a20
        let y = v.x * a01 + v.y * a11 + v.z * a21
        let z = v.x * a02 + v.y * a12 + v.z * a22
        return CyclicNoise.vec3(x, y, z);
    }
}

fileprivate func sin(_ v: CyclicNoise.vec3) -> CyclicNoise.vec3 { return CyclicNoise.vec3(sin(v.x), sin(v.y), sin(v.z)) }
fileprivate func cos(_ v: CyclicNoise.vec3) -> CyclicNoise.vec3 { return CyclicNoise.vec3(cos(v.x), cos(v.y), cos(v.z)) }
fileprivate func dot(_ u: CyclicNoise.vec3, _ v: CyclicNoise.vec3) -> Double { return u.dot(v) }
fileprivate func cross(_ u: CyclicNoise.vec3, _ v: CyclicNoise.vec3) -> CyclicNoise.vec3 { return u.cross(v) }
fileprivate func normalize(_ v: CyclicNoise.vec3) -> CyclicNoise.vec3 { return v.normalized }

extension CyclicNoise.vec3 {
    static func * (v: Self, s: Double) -> Self { return v.mul(s) }
    static func - (v: Self, s: Double) -> Self { return v.minus(s) }

    static func += (u: inout Self, v: Self) { u = u.plus(v) }
    static func *= (v: inout Self, s: Double) { v = v.mul(s) }
    static func *= (v: inout Self, m: CyclicNoise.mat3) { v = m.preMul(v) }
}
