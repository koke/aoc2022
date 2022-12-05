import Foundation

struct Range: CustomStringConvertible {
    let start: Int
    let end: Int
    var description: String {
        "(\(start),\(end))"
    }
    var asClosedRange: ClosedRange<Int> {
        start...end
    }
}

func parseRange(_ pair: String) -> Range {
    let rangeBounds = pair.components(separatedBy: "-")
        .map { Int($0)! }
    return Range(start: rangeBounds[0], end: rangeBounds[1])
}

func totalOverlap(first: Range, second: Range) -> Bool {
    return (first.start <= second.start && first.end >= second.end)
    || (second.start <= first.start && second.end >= first.end)
}

func partialOverlap(first: Range, second: Range) -> Bool {
    return first.asClosedRange.overlaps(second.asClosedRange)
}

struct Day4: Solution {
    let day = 4

    func solve(final: Bool, partTwo: Bool) throws -> String {
        try lines(final: final)
            .map { line in
                line
                    .components(separatedBy: ",")
                    .map(parseRange)
            }
            .map(debug(prefix: "ranges"))
            .map({ ranges in
                let first = ranges[0]
                let second = ranges[1]
                if partTwo {
                    return partialOverlap(first: first, second: second)
                } else {
                    return totalOverlap(first: first, second: second)
                }
            })
            .map(debug(prefix: "contains"))
            .filter { $0 }
            .count
            .description
    }
}
