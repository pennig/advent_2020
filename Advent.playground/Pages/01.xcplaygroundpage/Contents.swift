import Foundation

var input = readLines()

var ints = input.compactMap { Int($0) }.sorted()

let target = 2020

// part 1
let twoDigitProduct = twoDigitCalculation()

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

