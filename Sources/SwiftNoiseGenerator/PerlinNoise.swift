import Foundation
// https://mrl.nyu.edu/~perlin/noise/
// https://flafla2.github.io/2014/08/09/perlinnoise.html

public struct PerlinNoise: NoiseGenerator {

    public init() {}

    public func noise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return (perlinNoise(x, y, z) + 1) / 2
    }

    /// perlin noise (raw)
    ///
    /// - Parameters:
    ///     - x: The *x* component of the vector.
    ///     - y: The *y* component of the vector.
    ///     - z: The *z* component of the vector.
    /// - Returns: noise value (-1.0 ≦ noise ≦ +1.0)
    func perlinNoise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        let xi: Int = Int(floor(x)) & 255
        let yi: Int = Int(floor(y)) & 255
        let zi: Int = Int(floor(z)) & 255
        let xf: Double = x - floor(x)
        let yf: Double = y - floor(y)
        let zf: Double = z - floor(z)
        let u: Double = fade(xf)
        let v: Double = fade(yf)
        let w: Double = fade(zf)
        let aaa: Int = p[p[p[xi    ] + yi    ] + zi    ]
        let aba: Int = p[p[p[xi    ] + yi + 1] + zi    ]
        let aab: Int = p[p[p[xi    ] + yi    ] + zi + 1]
        let abb: Int = p[p[p[xi    ] + yi + 1] + zi + 1]
        let baa: Int = p[p[p[xi + 1] + yi    ] + zi    ]
        let bba: Int = p[p[p[xi + 1] + yi + 1] + zi    ]
        let bab: Int = p[p[p[xi + 1] + yi    ] + zi + 1]
        let bbb: Int = p[p[p[xi + 1] + yi + 1] + zi + 1]
        return lerp(w,
                    lerp(v,
                         lerp(u,
                              grad(aaa, xf,     yf,     zf),
                              grad(baa, xf - 1, yf,     zf)),
                         lerp(u,
                              grad(aba, xf,     yf - 1, zf),
                              grad(bba, xf - 1, yf - 1, zf))),
                    lerp(v,
                         lerp(u,
                              grad(aab, xf,     yf,     zf - 1),
                              grad(bab, xf - 1, yf,     zf - 1)),
                         lerp(u,
                              grad(abb, xf,     yf - 1, zf - 1),
                              grad(bbb, xf - 1, yf - 1, zf - 1))))
    }
    private func fade(_ t: Double) -> Double { return t * t * t * (t * (t * 6 - 15) + 10) }
    private func lerp(_ t: Double, _ a: Double, _ b: Double) -> Double { return a + t * (b - a) }
    private func grad(_ hash: Int, _ x: Double, _ y: Double, _ z: Double) -> Double {
        switch (hash & 15) {
        case 0: return  x + y
        case 1: return -x + y
        case 2: return  x - y
        case 3: return -x - y
        case 4: return  x + z
        case 5: return -x + z
        case 6: return  x - z
        case 7: return -x - z
        case 8: return  y + z
        case 9: return -y + z
        case 10: return  y - z
        case 11: return -y - z
        case 12: return  y + x
        case 13: return -y + z
        case 14: return  y - x
        case 15: return -y - z
        default: return 0 // never happens
        }
    }

    struct Permutation {
        let table: [Int] = [
          151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
          140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
          247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
          57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68,
          175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111,
          229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
          102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208,
          89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109,
          198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147,
          118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182,
          189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70,
          221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108,
          110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251,
          34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235,
          249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204,
          176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114,
          67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
        ]
        subscript(i: Int) -> Int { return table[i % 256] }
    }

    private let p = Permutation()
}
