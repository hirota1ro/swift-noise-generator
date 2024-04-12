import Foundation
// Simplex Noise Generator
// Original Source:
// https://github.com/SRombauts/SimplexNoise/blob/master/references/SimplexNoise.java

public struct SimplexNoise: NoiseGenerator {

    public init() {}

    let grad: [Point3D] = [
      Point3D(1, 1, 0), Point3D(-1, 1, 0), Point3D(1, -1, 0), Point3D(-1, -1, 0),
      Point3D(1, 0, 1), Point3D(-1, 0, 1), Point3D(1, 0, -1), Point3D(-1, 0, -1),
      Point3D(0, 1, 1), Point3D(0, -1, 1), Point3D(0, 1, -1), Point3D(0, -1, -1)
    ]

    struct P {
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
        subscript(i: Int) -> Int { return table[i & 255] }
    }
    let p = P()

    // Skewing and unskewing factors
    let F: Double = 1.0/3.0
    let G: Double = 1.0/6.0

    public func noise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        return (simplexNoise(x, y, z) + 1) / 2
    }

    /// simplex noise (raw)
    ///
    /// - Parameters:
    ///     - x: The *x* component of the vector.
    ///     - y: The *y* component of the vector.
    ///     - z: The *z* component of the vector.
    /// - Returns: noise value (-1.0 ≦ noise ≦ +1.0)
    func simplexNoise(_ x: Double, _ y: Double, _ z: Double) -> Double {
        // Very nice and simple skew factor for 3D
        // let s: Double = (x + y + z) * F
        // Skew the input space to determine which simplex cell we're in
        let v = Point3D(x, y, z)
        let s = v.bar * F
        let vs = v + Point3D(s, s, s)
        let idx0 = Index3D(vs)
        let u = Point3D(idx0)
        let t = u.bar * G
        // Unskew the cell origin back to (x,y,z) space
        // The x,y,z distances from the cell origin
        let v0 = v - (u - Point3D(t, t, t))
        // For the 3D case, the simplex shape is a slightly irregular tetrahedron.
        // Determine which simplex we are in.
        let (idx1, idx2) = f(v0)
        // Offsets for second corner of simplex in (i0,j0,k0) coords
        // Offsets for third corner of simplex in (i,j,k) coords
        // A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
        // a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
        // a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
        // c = 1/6.
        // Offsets for second corner in (x,y,z) coords
        let v1 = v0 - Point3D(idx1) + Point3D(G, G, G)
        // Offsets for third corner in (x,y,z) coords
        let v2 = v0 - Point3D(idx2) + (Point3D(G, G, G) * 2.0)
        // Offsets for last corner in (x,y,z) coords
        let v3 = v0 - Point3D(1.0, 1.0, 1.0) + (Point3D(G, G, G) * 3.0)
        // Work out the hashed gradient indices of the four simplex corners
        let i: Int = idx0.i & 255
        let j: Int = idx0.j & 255
        let k: Int = idx0.k & 255
        let g0: Int = p[i          + p[j          + p[k         ]]] % 12
        let g1: Int = p[i + idx1.i + p[j + idx1.j + p[k + idx1.k]]] % 12
        let g2: Int = p[i + idx2.i + p[j + idx2.j + p[k + idx2.k]]] % 12
        let g3: Int = p[i      + 1 + p[j      + 1 + p[k      + 1]]] % 12
        // Noise contributions from the four corners
        // Calculate the contribution from the four corners
        // Add contributions from each corner to get the final noise value.
        // The result is scaled to stay just inside [-1,1]
        return 32.0 * (n(grad[g0], v0) + n(grad[g1], v1) + n(grad[g2], v2) + n(grad[g3], v3))
    }

    func f(_ v: Point3D) -> (Index3D, Index3D) {
        if (v.x >= v.y) {
            if (v.y >= v.z) { // X Y Z order
                return (Index3D(1, 0, 0), Index3D(1, 1, 0))
            } else if (v.x >= v.z) { // X Z Y order
                return (Index3D(1, 0, 0), Index3D(1, 0, 1))
            } else { // Z X Y order
                return (Index3D(0, 0, 1), Index3D(1, 0, 1))
            }
        } else { // x<y
            if (v.y < v.z) { // Z Y X order
                return (Index3D(0, 0, 1), Index3D(0, 1, 1))
            } else if (v.x < v.z) { // Y Z X order
                return (Index3D(0, 1, 0), Index3D(0, 1, 1))
            } else { // Y X Z order
                return (Index3D(0, 1, 0), Index3D(1, 1, 0))
            }
        }
    }

    func n(_ g: Point3D, _ v: Point3D) -> Double {
        let t: Double = 0.6 - v.sqr2
        if (t < 0) {
            return 0.0
        } else {
            return t * t * t * t * g.dot(v)
        }
    }

    // Inner class to speed upp gradient computations
    // (array access is a lot slower than member access)
    struct Point3D {
        let x: Double
        let y: Double
        let z: Double

        init(_ x: Double, _ y: Double, _ z: Double) {
            self.x = x
            self.y = y
            self.z = z
        }

        func dot(_ p: Point3D) -> Double { return self.x*p.x + self.y*p.y + self.z*p.z }

        static func + (a: Point3D, b: Point3D) -> Point3D { return Point3D(a.x + b.x, a.y + b.y, a.z + b.z) }
        static func - (a: Point3D, b: Point3D) -> Point3D { return Point3D(a.x - b.x, a.y - b.y, a.z - b.z) }
        static func * (a: Point3D, b: Double) -> Point3D { return Point3D(a.x * b, a.y * b, a.z * b) }
        static func / (a: Point3D, b: Double) -> Point3D { return Point3D(a.x / b, a.y / b, a.z / b) }

        init(_ idx: Index3D) {
            self.x = Double(idx.i)
            self.y = Double(idx.j)
            self.z = Double(idx.k)
        }

        var sqr2: Double { return x*x + y*y + z*z }
        var bar: Double { return x + y + z }
    }

    struct Index3D {
        let i: Int
        let j: Int
        let k: Int

        init(_ i: Int, _ j: Int, _ k: Int) {
            self.i = i
            self.j = j
            self.k = k
        }

        init(_ x: Double, _ y: Double, _ z: Double) {
            self.i = Int(floor(x))
            self.j = Int(floor(y))
            self.k = Int(floor(z))
        }

        init(_ p: Point3D) {
            self.init(p.x, p.y, p.z)
        }
    }
}
