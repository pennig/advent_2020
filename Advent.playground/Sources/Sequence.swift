import Foundation

public extension Collection where Element == Int {
    func twoElementsAddingTo(_ target: Element) -> (Element, Element)? {
        let sorted = self.sorted()
        var start = sorted.startIndex
        var end = sorted.endIndex.advanced(by: -1)
        while start != end {
            let sum = sorted[start] + sorted[end]
            if sum == target {
                return (sorted[start], sorted[end])
            } else if sum > target {
                end = end.advanced(by: -1)
            } else {
                start = start.advanced(by: 1)
            }
        }
        return nil
    }
}
