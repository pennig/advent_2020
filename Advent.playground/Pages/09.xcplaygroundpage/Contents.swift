import Foundation

let input = readLines().compactMap(Int.init)
var invalidNumber = 0

// part 1
var index = input.startIndex.advanced(by: 25)
while index < input.endIndex {
    let target = input[index]
    let range = index.advanced(by: -25)...index.advanced(by: -1)
    // Thanks, Day 1!
    if input[range].twoElementsAddingTo(target) == nil {
        invalidNumber = target
        break
    }
    index = index.advanced(by: 1)
}

// part 2
if let slice = input[input.startIndex..<index].sliceAddingTo(invalidNumber)?.sorted() {
    let weakness = slice.first! + slice.last!
    print(weakness)
}

extension RandomAccessCollection where Element == Int, Index: Strideable {
    func sliceAddingTo(_ target: Element) -> Self.SubSequence? {
        var start = startIndex
        var end = startIndex.advanced(by: 1)
        var runningTotal = self[start] + self[end]
        while end < endIndex {
            if runningTotal == target {
                return self[start...end]
            }
            if runningTotal > target {
                runningTotal -= self[start]
                start = start.advanced(by: 1)
            }
            if runningTotal < target || start > end {
                end = end.advanced(by: 1)
                guard end < endIndex else { return nil }
                runningTotal += self[end]
            }
        }
        return nil
    }
}
