import Foundation

public func readInput() -> [String] {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
        return []
    }
    do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        return data.components(separatedBy: .newlines).dropLast()
    } catch {
        print(error)
        return []
    }
}
