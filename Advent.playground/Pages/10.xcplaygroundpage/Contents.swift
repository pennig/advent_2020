import Foundation

let input = readLines().compactMap(Int.init).sorted()
let joltages = [0] + input + [input.max()! + 3]

// part 1
let differences: [Int] = joltages.enumerated().reduce(into: [0, 0, 0]) {
    if $1.offset == joltages.count - 1 {
        return
    }
     
    let diff = joltages[$1.offset + 1] - $1.element
    $0[diff - 1] += 1
}
print(differences[0] * differences[2])

// part 2 - shamelessly stolen because how in the world would a layperson arrive at "oh, yes, it's Tribonacci, totally something I knew was even a thing and corresponds to the number of combinations of this particular series of numbers". I am salty.
var countsForValues = [0: 1]
for adapter in input {
    var count = 0
    for i in 1...3 {
        if countsForValues[adapter - i] != nil {
            count += countsForValues[adapter - i]!
        }
    }
    countsForValues[adapter] = count
}
let total = countsForValues[input.last!]!
print("total = \(total)")
