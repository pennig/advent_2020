import Foundation

let input = readLines().split(separator: "")

// part 1
let groupUniqueQuestions = input.map {
    Set($0.joined())
}.reduce(0) { $0 + $1.count }

// part 2
let groupSharedQuestions = input.map {
    $0.reduce(Set("abcdefghijklmnopqrstuvwxyz")) { $0.intersection(Set($1)) }
}.reduce(0) { $0 + $1.count }
