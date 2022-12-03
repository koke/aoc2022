//
//  main.swift
//  aoc2022
//
//  Created by Jorge Bernal on 1/12/22.
//

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
}

func day1(final: Bool, limit: Int = 1) throws {
    let input = try loadInput(day: 1, final: final)

    let lines = input.components(separatedBy: "\n")
    var elves: [Int] = []
    var elf = 0
    lines.forEach { line in
        if let value = Int(line) {
            elf += value
        } else {
            elves.append(elf)
            elf = 0
        }
    }
    elves.append(elf)
    let result = Array(elves.sorted().reversed().prefix(limit))
    print(result.reduce(0, +))
}

func day1a(final: Bool, limit: Int = 1) throws {
    let input = try loadInput(day: 1, final: final)

    let result = input
        .components(separatedBy: "\n\n")
        .map { input in
            input.components(separatedBy: "\n")
                .map { Int($0)! }
                .sum()
        }
        .sorted()
        .suffix(limit)
        .sum()

    print(result)
}

func day2(final: Bool) throws -> Any {
    let input = try loadInput(day: 2, final: final)

    enum Shape {
        case rock
        case paper
        case scissors

        init(encoded: String) {
            switch encoded {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissors
            default:
                fatalError()
            }
        }

        func outcomeScore(against: Shape) -> Int {
            switch (self, against) {
            case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
                return 6
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
                return 3
            default:
                return 0
            }
        }
    }

    struct Play {
        let theirs: Shape
        let mine: Shape

        init(line: String) {
            let items = line.components(separatedBy: .whitespaces)
            theirs = Shape(encoded: items[0])
            mine = Shape(encoded: items[1])
        }

        var totalScore: Int {
            shapeScore + outcomeScore
        }

        var shapeScore: Int {
            switch mine {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissors:
                return 3
            }
        }

        var outcomeScore: Int {
            mine.outcomeScore(against: theirs)
        }
    }

    return input.components(separatedBy: "\n")
        .map(Play.init(line:))
        .map(\.totalScore)
        .sum()
}

func day2a(final: Bool) throws -> Any {
    let input = try loadInput(day: 2, final: final)

    enum Shape: CaseIterable {
        case rock
        case paper
        case scissors

        init(encoded: String) {
            switch encoded {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissors
            default:
                fatalError()
            }
        }

        func outcomeScore(against: Shape) -> Int {
            switch (self, against) {
            case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
                return 6
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
                return 3
            default:
                return 0
            }
        }
    }

    struct Play {
        let theirs: Shape
        let mine: Shape

        init(line: String) {
            let items = line.components(separatedBy: .whitespaces)
            theirs = Shape(encoded: items[0])

            let outcomeScore: Int
            switch items[1] {
            case "X": outcomeScore = 0
            case "Y": outcomeScore = 3
            case "Z": outcomeScore = 6
            default: fatalError()
            }
            mine = Shape.allCases.first(where: { $0.outcomeScore(against: Shape(encoded: items[0])) == outcomeScore})!
        }

        var totalScore: Int {
            shapeScore + outcomeScore
        }

        var shapeScore: Int {
            switch mine {
            case .rock:
                return 1
            case .paper:
                return 2
            case .scissors:
                return 3
            }
        }

        var outcomeScore: Int {
            mine.outcomeScore(against: theirs)
        }
    }

    return input.components(separatedBy: "\n")
        .map(Play.init(line:))
        .map(\.totalScore)
        .sum()
}

func day3(final: Bool) throws -> Int {
    let input = try loadInput(day: 3, final: final)
    func itemPriority(_ item: Character) -> Int {
        if item.isUppercase {
            return Int(item.asciiValue! - Character("A").asciiValue! + 27)
        } else {
            return Int(item.asciiValue! - Character("a").asciiValue! + 1)
        }
    }

    func splitRucksack(_ rucksack: String) -> (String, String) {
        let compartmentSize = rucksack.count / 2
        return (String(rucksack.prefix(compartmentSize)), String(rucksack.suffix(compartmentSize)))
    }

    func findWrongItem(compartments: (String, String)) -> Character {
        return compartments.0.first { compartments.1.contains($0) }!
    }

    func debug<T>(prefix: String) -> ((T) -> T) {
        return { input in
            print("\(prefix): \(input)")
            return input
        }
    }

    return input
        .components(separatedBy: "\n")
        .map(splitRucksack)
        .map(findWrongItem(compartments:))
        .map(debug(prefix: "wrongItem"))
        .map(itemPriority(_:))
        .map(debug(prefix: "priority"))
        .sum()
}

func day3a(final: Bool) throws -> Int {
    let input = try loadInput(day: 3, final: final)
    func itemPriority(_ item: Character) -> Int {
        if item.isUppercase {
            return Int(item.asciiValue! - Character("A").asciiValue! + 27)
        } else {
            return Int(item.asciiValue! - Character("a").asciiValue! + 1)
        }
    }

    func splitRucksack(_ rucksack: String) -> (String, String) {
        let compartmentSize = rucksack.count / 2
        return (String(rucksack.prefix(compartmentSize)), String(rucksack.suffix(compartmentSize)))
    }

    func findWrongItem(compartments: (String, String)) -> Character {
        return compartments.0.first { compartments.1.contains($0) }!
    }

    func findCommonItem(elves: [String]) -> Character {
        elves[0].first { character in
            elves.dropFirst().allSatisfy({ $0.contains(character) })
        }!
    }

    func debug<T>(prefix: String) -> ((T) -> T) {
        return { input in
            print("\(prefix): \(input)")
            return input
        }
    }

    return input
        .components(separatedBy: "\n")
        .chunked(into: 3)
        .map(findCommonItem(elves:))
        .map(debug(prefix: "commonItem"))
        .map(itemPriority(_:))
        .map(debug(prefix: "priority"))
        .sum()
}

let result = try day3a(final: true)
print(result)
