import Foundation

var input = [1,20,11,6,12,0]

var turn = 0
// map of numbers and the last turn they were read
var memory: [Int: (Int,Int)] = [:]
var lastSpoken: Int = 0

let turns = 30_000_000

memory.reserveCapacity(turns)
for i in input {
    turn += 1
    memory[i] = (turn, 0)
}

func step() {
    turn += 1
    
    let spokenMemory = memory[lastSpoken, default: (turn, 0)]
    if spokenMemory.1 == 0 {
        lastSpoken = 0
    } else {
        lastSpoken = spokenMemory.0 - spokenMemory.1
    }
    memory[lastSpoken] = (turn, memory[lastSpoken]?.0 ?? 0)
}

for _ in 0..<turns {
    step()
}
print(lastSpoken)
