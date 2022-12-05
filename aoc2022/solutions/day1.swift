import Foundation

struct Day1: Solution {
    let day = 1

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let limit = partTwo ? 3 : 1

        return try input(final: final)
            .components(separatedBy: "\n\n")
            .map { input in
                input.components(separatedBy: "\n")
                    .map { Int($0)! }
                    .sum()
            }
            .sorted()
            .suffix(limit)
            .sum()
            .description

    }
}
