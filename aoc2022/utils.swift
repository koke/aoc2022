import Foundation

enum Errors: Error {
    case notImplemented
}

func loadInput(day: Int, final: Bool) throws -> String {
    let suffix = final ? "input" : "test"
    let name = "day\(day)-\(suffix)"
    let path = "/Users/koke/Documents/Projects/aoc2022/aoc2022/input/\(name)"
    return try String(contentsOfFile: path).trimmingCharacters(in: .newlines)
}

func debug<T>(prefix: String) -> ((T) -> T) {
    return { input in
        print("\(prefix): \(input)")
        return input
    }
}

extension Array where Element: AdditiveArithmetic {
    func sum() -> Element {
        reduce(.zero, +)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    func debug(prefix: String) -> Self {
        print("\(prefix): \(self)")
        return self
    }
}
