import Foundation

var input = readLines().map { $0.map({ Seat(rawValue: $0)! }) }

enum Seat: Character, CustomStringConvertible {
    case floor = "."
    case empty = "L"
    case occupied = "#"
    
    var description: String {
        String(rawValue)
    }
}

extension Array where Element == [Seat] {
    func seat(_ x: Int, _ y: Int) -> Seat? {
        guard indices.contains(y) else { return nil }
        guard self[y].indices.contains(x) else { return nil }
        return self[y][x]
    }
    
    func adjacentCount(x: Int, y: Int) -> Int {
        [
            seat(x-1, y-1),
            seat(x, y-1),
            seat(x+1, y-1),
            seat(x-1, y),
            seat(x+1, y),
            seat(x-1, y+1),
            seat(x, y+1),
            seat(x+1, y+1),
        ].filter({ $0 == .occupied }).count
    }
}

func step() -> [[Seat]] {
    var output = input
    for y in input.indices {
        for x in input[y].indices {
            if input[y][x] == .empty && input.adjacentCount(x: x, y: y) == 0 {
                output[y][x] = .occupied
            } else if input[y][x] == .occupied && input.adjacentCount(x: x, y: y) >= 4 {
                output[y][x] = .empty
            }
        }
    }
    
    return output
}

func printOutput() {
    print(input.map({ $0.map({ String($0.rawValue) }).joined() }).joined(separator: "\n"))
}

while true {
    let output = step()
    if output == input {
        break
    }
    input = output
    printOutput()
    print("---")
}


