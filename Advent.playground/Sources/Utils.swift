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
    /// Test whether a string matches a regex.
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    /// Returns a dictionary of named groups matched by a regex pattern.
    func parseRegex(_ pattern: String, groupNames: Set<String>) -> [String: String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [])  else {
            return nil
        }
        
        let fullRange = NSRange(self.startIndex..<self.endIndex, in: self)
        guard let match = regex.firstMatch(in: self, options: [], range: fullRange) else {
            return nil
        }
        
        let output: [String: String] = groupNames.reduce(into: [:]) { out, groupName in
            let groupRange = match.range(withName: groupName)
            if groupRange.location != NSNotFound, let range = Range(groupRange, in: self) {
                out[groupName] = String(self[range])
            }
        }
        return output
    }
    
    /// Credit to Sebastian Celis
    var nsRange: NSRange {
        return NSMakeRange(0, (self as NSString).length)
    }

    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }
    
    func enumerateMatches(
        withPattern pattern: String,
        patternOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        using block: ([String]) -> ()) throws
    {
        let regex = try NSRegularExpression(pattern: pattern, options: patternOptions)
        return try enumerateMatches(
            withRegularExpression: regex,
            options: matchingOptions,
            using: block
        )
    }

    func enumerateMatches(
        withRegularExpression regex: NSRegularExpression,
        options: NSRegularExpression.MatchingOptions = [],
        using block: ([String]) -> ()) throws
    {
        let numGroups = regex.numberOfCaptureGroups
        regex.enumerateMatches(in: self, options: options, range: nsRange, using: { result, _, _ in
            if let result = result {
                var groups: [String] = []
                groups.append(substring(with: result.range))
                for i in 0..<numGroups {
                    let groupRange = result.range(at: i + 1)
                    if groupRange.location == NSNotFound {
                        groups.append("")
                    } else {
                        groups.append(substring(with: groupRange))
                    }
                }
                block(groups)
            }
        })
    }
}
