import Foundation

enum SolutionFactory {
    static let solutions: [Solution] = [
        Day1(), Day2(), Day3(), Day4(), Day5(), Day6(), Day7(), Day8(), Day9(), Day10(),
        Day11(), Day12(), Day13(), Day14(), Day15(), Day16(), Day17(), Day18(), Day19(),
        Day20(), Day21(), Day22(), Day23(), Day24(), Day25()
    ]

    static func solution(day: Int) -> Solution? {
        solutions[day - 1]
    }
}

let today = 10
let solution = SolutionFactory.solution(day: today)!

print("Day \(today)")
print("Part 1, test: \(try solution.solve(final: false, partTwo: false))")
print("Part 1, final: \(try solution.solve(final: true, partTwo: false))")
print("Part 2, test: \(try solution.solve(final: false, partTwo: true))")
print("Part 2, final: \(try solution.solve(final: true, partTwo: true))")
