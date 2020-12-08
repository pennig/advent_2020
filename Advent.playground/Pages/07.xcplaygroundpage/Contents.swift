import Foundation

let rules = Rules(readLines())

typealias Rules = Dictionary<String, Bag>
extension Rules {
    init(_ input: [String]) {
        self.init()
        
        input.forEach { line in
            let components = line.components(separatedBy: " bags contain ")
            self[components[0]] = Bag(components[1])
        }
    }
}

typealias Bag = Dictionary<String, Int>
extension Bag {
    init(_ contains: String) {
        self.init()
        guard contains != "no other bags." else { return }
        
        try? contains.enumerateMatches(withPattern: #"([0-9]+) (.+?) bags?[\.,]"#) {
            self[$0[2]] = Int($0[1])
        }
    }
}

func colorsContainingColor(_ color: String) -> Set<String> {
    rules.reduce(into: Set<String>()) { out, rule in
        if rule.value.keys.contains(color) {
            out.insert(rule.key)
            out.formUnion(colorsContainingColor(rule.key))
        }
    }
}

func bagsInsideBagColor(_ color: String) -> Int {
    rules[color]?.reduce(0) { $0 + $1.value * (1 + bagsInsideBagColor($1.key)) } ?? 0
}

print(colorsContainingColor("shiny gold").count)
print(bagsInsideBagColor("shiny gold"))
