import Foundation

let input = readInput().components(separatedBy: "\n\n").map({ $0.components(separatedBy: "\n") })

let rules = input[0].reduce(into: [String: Set<Int>](), {
    let line = $1.components(separatedBy: ": ")
    var set: Set<Int> = []
    try? line[1].enumerateMatches(withPattern: #"(\d+)-(\d+)"#) {
        set.formUnion(Set(Int($0[1])!...Int($0[2])!))
    }
    $0[line[0]] = set
})
let myTicket = input[1][1].components(separatedBy: ",").compactMap(Int.init)
let tickets = input[2].dropFirst().dropLast().map({ $0.components(separatedBy: ",").compactMap(Int.init) })

let allPossibilities = rules.values.reduce([]) { $1.union($0) }

print(part1(), part2())

// part 1
func part1() -> String {
    let errors = tickets.compactMap(Set.init).map { $0.subtracting(allPossibilities).reduce(0, +) }
    return errors.reduce(0, +).description
}

// part 2
func part2() -> String {
    // filter out invalid tickets
    let validTickets = [myTicket] + tickets.filter({
        Set($0).subtracting(allPossibilities).isEmpty
    })
    
    // pivot the tickets into their respective fields
    var fields: [Set<Int>] = []
    for i in 0..<myTicket.count {
        fields.append(Set(validTickets.map({ $0[i] })))
    }
    
    // loop over fields and associate them with their names by process of elimination
    var matchedFields: [String: Int] = [:]
    while matchedFields.keys.count < rules.keys.count {
        for (i, field) in fields.enumerated() {
            var matches: [String] = []
            for (key, value) in rules.filter({ !matchedFields.keys.contains($0.key) }) {
                if field.subtracting(value).isEmpty {
                    matches.append(key)
                }
            }
            if matches.count == 1 {
                matchedFields[matches.first!] = i
            }
        }
    }
    
    // multiply the "departure" fields
    return matchedFields.reduce(1) {
        if $1.key.contains("departure") {
            return $0 * myTicket[$1.value]
        } else {
            return $0
        }
    }.description
}
