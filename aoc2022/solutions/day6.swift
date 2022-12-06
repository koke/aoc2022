import Foundation

func findFirstUniqueSequence(string: String, length: Int) throws -> Int {
    var index = string.index(string.startIndex, offsetBy: length)
    while index != string.endIndex {
        let chunk = string[string.index(index, offsetBy: -length)..<index]
        print(chunk)
        if Set(chunk).count == length {
            return string.distance(from: string.startIndex, to: index)
        }
        index = string.index(after: index)
    }
    throw ParseError()
}

struct Day6: Solution {
    let day = 6

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let length = partTwo ? 14 : 4

        return try lines(final: final)
            .map { try findFirstUniqueSequence(string: $0, length: length) }
            .map { String($0) }
            .joined(separator: "\n")
    }
}
