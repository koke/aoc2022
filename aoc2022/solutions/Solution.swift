import Foundation

protocol Solution {
    var day: Int { get }

    func solve(final: Bool, partTwo: Bool) throws -> String
}

extension Solution {
    func input(final: Bool) throws -> String {
        try loadInput(day: day, final: final)
    }

    func lines(final: Bool) throws -> [String] {
        try input(final: final).components(separatedBy: "\n")
    }
}
