import Foundation

let input = readLines()
let pattern = #"^(?<firstDigit>\d+)-(?<lastDigit>\d+) (?<letter>[a-z]): (?<password>[a-z]+)$"#

// part 1
let otherValidPasswordCount = input.filter({ rule in
    guard let components = extractComponents(rule) else { return false }
    
    let occurrences = components.password.filter({ $0 == components.letter }).count
    return (components.firstDigit...components.lastDigit).contains(occurrences)
}).count

// part 2
let ourValidPasswordCount = input.filter({ rule in
    guard let components = extractComponents(rule) else { return false }
    
    let password = components.password
    let first = password.index(password.startIndex, offsetBy: components.firstDigit-1)
    let second = password.index(password.startIndex, offsetBy: components.lastDigit-1)
    
    let firstMatch = password[first] == components.letter
    let secondMatch = password[second] == components.letter
    return (firstMatch || secondMatch) && firstMatch != secondMatch
}).count

/* -------------------------------------------------------------------------- */

func extractComponents(_ string: String) -> (firstDigit: Int, lastDigit: Int, letter: Character, password: String)? {
    guard let components = string.parseRegex(pattern, groupNames: ["firstDigit", "lastDigit", "letter", "password"]) else {
        return nil
    }
    
    guard
        let firstDigit = Int(components["firstDigit"] ?? ""),
        let lastDigit = Int(components["lastDigit"] ?? ""),
        let letter = components["letter"]?.first,
        let password = components["password"]
    else {
        return nil
    }

    return (firstDigit, lastDigit, letter, password)
}
