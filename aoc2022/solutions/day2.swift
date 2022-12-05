import Foundation

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

    init(partOne line: String) {
        let items = line.components(separatedBy: .whitespaces)
        theirs = Shape(encoded: items[0])
        mine = Shape(encoded: items[1])
    }

    init(partTwo line: String) {
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

struct Day2: Solution {
    let day = 2

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let playMaker = partTwo ? Play.init(partTwo:) : Play.init(partOne:)
        
        return try lines(final: final)
            .map(playMaker)
            .map(\.totalScore)
            .sum()
            .description
    }
}
