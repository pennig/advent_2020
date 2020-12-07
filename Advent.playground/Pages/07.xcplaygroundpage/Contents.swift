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
    var colorsInside: Set<String> { Set(keys) }
    
    init(_ contains: String) {
        self.init()
        guard contains != "no other bags." else { return }
        
        try? contains.enumerateMatches(withPattern: #"([0-9]+) (.+?) bags?[\.,]"#) {
            self[$0[2]] = Int($0[1])
        }
    }
}


func colorsContainingColor(_ color: String) -> Set<String> {
    // So we don't have to visit the same color multiple times
    var colorCache = [String: Set<String>]()
    
    func colorsInBagColor(_ bagColor: String, containing color: String) -> Set<String> {
        if let cache = colorCache[bagColor] {
            return cache
        }
        
        var output = Set<String>()
        
        let colorsInside = rules[bagColor]!.colorsInside
        if colorsInside.contains(color) {
            output.insert(bagColor)
        }
        colorsInside.forEach {
            let foundColors = colorsInBagColor($0, containing: color)
            if !foundColors.isEmpty {
                output.formUnion(foundColors)
                output.insert(bagColor)
            }
        }
        colorCache[bagColor] = output
        
        return output
    }
    
    return rules.keys.reduce(into: Set<String>()) { out, key in
        out.formUnion(colorsInBagColor(key, containing: color))
    }
}

func bagsInsideBagColor(_ color: String) -> Int {
    var count = 0
    for (c, num) in rules[color]! {
        count += num + num * bagsInsideBagColor(c)
    }
    return count
}

print(colorsContainingColor("shiny gold").count)
print(bagsInsideBagColor("shiny gold"))
