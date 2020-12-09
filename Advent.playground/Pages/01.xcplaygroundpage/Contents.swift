import Foundation

var input = readLines()

var ints = input.compactMap { Int($0) }.sorted()

let target = 2020

// part 1
let twoDigitProduct = twoDigitCalculation()
if let factors = ints.twoElementsAddingTo(target) {
    let twoDigitProduct2 = factors.0 * factors.1
    print(twoDigitProduct2)
}

// part 2
let threeDigitProduct = threeDigitCalculation()

/* -------------------------------------------------------------------------- */

func twoDigitCalculation() -> Int {
    let enumerated = ints.enumerated()
    outer: for (idx, i) in enumerated {
        for j in ints.suffix(from: idx + 1) {
            if i + j == target {
                return i * j
            }
            if i + j > target {
                continue outer
            }
        }
    }
    return -1
}

func threeDigitCalculation() -> Int {
    let enumerated = ints.enumerated()
    outer: for (idxI, i) in enumerated {
        inner: for (idxJ, j) in ints.suffix(from: idxI + 1).enumerated() {
            for k in ints.suffix(from: idxJ + 1) {
                if i + j + k == target {
                    return i * j * k
                }
                if i + j + k > target {
                    continue inner
                }
            }
        }
    }
    return -1
}

extension Sequence where Element == Int {
    func twoElementsAddingTo(_ target: Element) -> (Element, Element)? {
        let sorted = self.sorted()
        var start = sorted.startIndex
        var end = sorted.endIndex.advanced(by: -1)
        while start != end {
            let sum = sorted[start] + sorted[end]
            if sum == target {
                return (sorted[start], sorted[end])
            } else if sum > target {
                end = end.advanced(by: -1)
            } else {
                start = start.advanced(by: 1)
            }
        }
        return nil
    }
}
