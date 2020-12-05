import Foundation

public func readInput() -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
        return ""
    }
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print(error)
        return ""
    }
}

public func readLines() -> [String] {
    readInput().components(separatedBy: .newlines).dropLast()
}

public extension String {
    /// Test whether a string matches a regexp
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
