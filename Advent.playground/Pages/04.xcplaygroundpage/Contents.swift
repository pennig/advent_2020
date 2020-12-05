import Foundation

let input = readInput()
let passports = parse(input)

// part 1
let numberOfCompletePassports = passports.filter({ $0.isComplete }).count
print("Number with all required fields: \(numberOfCompletePassports)")

// part 2
let numberOfValidPassports = passports.filter({ $0.isValid }).count
print("Number of valid passports: \(numberOfValidPassports)")

/* -------------------------------------------------------------------------- */

struct Passport {
    static let requiredFields: Set = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    
    let fields: [String: String]
    
    var isComplete: Bool {
        Set(fields.keys).isSuperset(of: Self.requiredFields)
    }
    
    var isValid: Bool {
        guard isComplete else { return false }
        
        let byr = Int(fields["byr"]!) ?? 0
        guard (1920...2002).contains(byr) else { return false }

        let iyr = Int(fields["iyr"]!) ?? 0
        guard (2010...2020).contains(iyr) else { return false }

        let eyr = Int(fields["eyr"]!) ?? 0
        guard (2020...2030).contains(eyr) else { return false }

        let hgt = fields["hgt"]!
        let unit = hgt.suffix(2)
        let value = Int(hgt.dropLast(2)) ?? 0
        if unit == "in" {
            guard (59...76).contains(value) else { return false }
        } else if unit == "cm" {
            guard (150...193).contains(value) else { return false }
        } else {
            return false
        }
        
        guard fields["hcl"]! ~= "^#[0-9a-f]{6}$" else { return false }
        
        guard fields["ecl"]! ~= "^(amb|blu|brn|gry|grn|hzl|oth)$" else { return false }

        guard fields["pid"]! ~= "^[0-9]{9}$" else { return false }

        return true
    }
}

func parse(_ input: String) -> [Passport] {
    // split first by blank lines, and then again by newlines or spaces
    let chunks = input.components(separatedBy: "\n\n").map { $0.components(separatedBy: CharacterSet.whitespacesAndNewlines) }
    
    return chunks.map { chunk in
        let fields: [String: String] = chunk.reduce(into: [:]) { out, pair in
            let keyValue = pair.split(separator: ":")
            if let key = keyValue.first, let value = keyValue.last {
                out[String(key)] = String(value)
            }
        }
        return Passport(fields: fields)
    }
}
