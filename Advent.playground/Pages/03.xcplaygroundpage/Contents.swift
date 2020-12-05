import Foundation

let input = readLines()

// part 1
var numberOfTrees = numberOfTreesAlongSlope(across: 3)
print(numberOfTrees)

// part 2
var productOfAllSlopes = [
    numberOfTreesAlongSlope(across: 1),
    numberOfTreesAlongSlope(across: 3),
    numberOfTreesAlongSlope(across: 5),
    numberOfTreesAlongSlope(across: 7),
    numberOfTreesAlongSlope(across: 1, down: 2),
].reduce(1, *)
print(productOfAllSlopes)

/* -------------------------------------------------------------------------- */

func numberOfTreesAlongSlope(across: Int, down: Int = 1) -> Int {
    var count = 0
    for i in stride(from: input.startIndex, to: input.endIndex, by: down) {
        if input[i].at(i / down * across) == "#" {
            count += 1
        }
    }
    return count
}

extension String {
    func at(_ index: Int) -> String {
        var offset = index.quotientAndRemainder(dividingBy: count).remainder
        if offset < 0 {
            offset += count
        }
        let index = self.index(startIndex, offsetBy: offset)
        return String(self[index])
    }
}
