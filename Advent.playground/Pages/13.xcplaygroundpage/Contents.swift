import Foundation

let input = """
1001798
19,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,859,x,x,x,x,x,x,x,23,x,x,x,x,13,x,x,x,17,x,x,x,x,x,x,x,x,x,x,x,29,x,373,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37
""".split(separator: "\n")

print(input)

func part1() -> String {
    let earliestTime = Int(input[0]) ?? 0
    let busTimes = input[1].split(separator: ",").filter({ $0 != "x" }).map(String.init).compactMap(Int.init)
    var waitTime = 0
    while true {
        for bus in busTimes {
            if (earliestTime + waitTime) % bus == 0 {
                return (bus * waitTime).description
            }
        }
        waitTime += 1
    }
}

func part2() -> String {
    let timesAndOffsets = input[1].split(separator: ",").map(String.init).map(Int.init).enumerated().compactMap({ $0.element == nil ? nil : ($0.element!, $0.offset) })
    print(timesAndOffsets)
//    var offset = 0
//    var timestamp = timesAndOffsets[0].0
//    for t in timesAndOffsets.dropFirst() {
//        timestamp = lcm(a: timestamp, aOffset: offset, b: t.0, bOffset: t.1)
//        offset = t.1
//        print(timestamp)
//    }
//    return timestamp.description
    return crt(timesAndOffsets.map(\.0), timesAndOffsets.map(\.1)).description
}

print(part1())
print(part2())

//

// CRT lifted from https://rosettacode.org/wiki/Chinese_remainder_theorem#Swift
/*
 * Function: euclid
 * Usage: (r,s) = euclid(m,n)
 * --------------------------
 * The extended Euclidean algorithm subsequently performs
 * Euclidean divisions till the remainder is zero and then
 * returns the Bézout coefficients r and s.
 */

func euclid(_ m:Int, _ n:Int) -> (Int,Int) {
    if m % n == 0 {
        return (0,1)
    } else {
        let rs = euclid(n % m, m)
        let r = rs.1 - rs.0 * (n / m)
        let s = rs.0

        return (r,s)
    }
}

/*
 * Function: gcd
 * Usage: x = gcd(m,n)
 * -------------------
 * The greatest common divisor of two numbers a and b
 * is expressed by ax + by = gcd(a,b) where x and y are
 * the Bézout coefficients as determined by the extended
 * euclidean algorithm.
 */

func gcd(_ m:Int, _ n:Int) -> Int {
    let rs = euclid(m, n)
    return m * rs.0 + n * rs.1
}

func coprime(_ m:Int, _ n:Int) -> Bool {
    return gcd(m,n) == 1 ? true : false
}

//coprime(14,26)
//coprime(2,4)
/*
 * Function: crt
 * Usage: x = crt(a,n)
 * -------------------
 * The Chinese Remainder Theorem supposes that given the
 * integers n_1...n_k that are pairwise co-prime, then for
 * any sequence of integers a_1...a_k there exists an integer
 * x that solves the system of linear congruences:
 *
 *   x === a_1 (mod n_1)
 *   ...
 *   x === a_k (mod n_k)
 */

func crt(_ a_i:[Int], _ n_i:[Int]) -> Int {
    // There is no identity operator for elements of [Int].
    // The offset of the elements of an enumerated sequence
    // can be used instead, to determine if two elements of the same
    // array are the same.
    let divs = n_i.enumerated()

    // Check if elements of n_i are pairwise coprime divs.filter{ $0.0 < n.0 }
    divs.forEach{
        n in divs.filter{ $0.0 < n.0 }.forEach{
            assert(coprime(n.1, $0.1))
        }
    }

    // Calculate factor N
    let N = n_i.map{$0}.reduce(1, *)

    // Euclidean algorithm determines s_i (and r_i)
    var s:[Int] = []

    // Using euclidean algorithm to calculate r_i, s_i
    n_i.forEach{ s += [euclid($0, N / $0).1] }

    // Solve for x
    var x = 0
    a_i.enumerated().forEach{
        x += $0.1 * s[$0.0] * N / n_i[$0.0]
    }

    // Return minimal solution
    return x % N
}
