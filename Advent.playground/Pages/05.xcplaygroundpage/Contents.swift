import Foundation

let input = readLines()
let seatIds = input.map(seatId).sorted()

// part 1
let highestSeatId = seatIds.last

// part 2
let missingSeatId = findFirstGap(seatIds)

/* -------------------------------------------------------------------------- */

/// Converts a string of format "FBFBFBFRLR" into an Int
func seatId(_ string: String) -> Int {
    string.reversed().enumerated().reduce(0) { output, input -> Int in
        if input.element == "B" || input.element == "R" {
            return output | (1 << input.offset)
        } else {
            return output
        }
    }
}

/// Returns the first "gap" in an array of sequential Ints
func findFirstGap(_ ints: [Int]) -> Int {
    var lastInt: Int?
    for i in ints {
        guard let last = lastInt else {
            lastInt = i
            continue
        }
        if i > last + 1 {
            return last + 1
        }
        lastInt = i
    }
    return -1
}
