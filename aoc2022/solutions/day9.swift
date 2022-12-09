import Foundation

private struct Position: CustomStringConvertible, Hashable {
    var x: Int
    var y: Int

    static let initial: Self = .init(x: 0, y: 0)
    var description: String { "(\(x), \(y))"}
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

private struct RopeSection: CustomStringConvertible {
    var head: Position
    var tail: Position

    static let initial: Self = .init(head: .initial, tail: .initial)

    func movingHead(direction: Direction) -> RopeSection {
        var state = self
        state.moveHead(direction: direction)
        return state
    }

    mutating func moveHead(direction: Direction) {
        switch direction {
        case .up:
            head.y += 1
        case .down:
            head.y -= 1
        case .left:
            head.x -= 1
        case .right:
            head.x += 1
        }
        followTail()
    }

    mutating func followTail() {
        if (head.x == tail.x) {
            if head.y > tail.y + 1 {
                tail.y += 1
            } else if head.y < tail.y - 1 {
                tail.y -= 1
            }
        } else if (head.y == tail.y) {
            if head.x > tail.x + 1 {
                tail.x += 1
            } else if head.x < tail.x - 1 {
                tail.x -= 1
            }
        } else if head.x - tail.x + head.y - tail.y > 2 {
            tail.x += 1
            tail.y += 1
        } else if head.x - tail.x + tail.y - head.y > 2 {
            tail.x += 1
            tail.y -= 1
        } else if tail.x - head.x + head.y - tail.y > 2 {
            tail.x -= 1
            tail.y += 1
        } else if tail.x - head.x + tail.y - head.y > 2 {
            tail.x -= 1
            tail.y -= 1
        }
    }

    var description: String {
        "(H: \(head), T: \(tail))"
    }
}

private struct Rope {
    var sections: [RopeSection]

    var head: Position {
        sections.first!.head
    }

    var tail: Position {
        sections.last!.tail
    }

    init(length: Int) {
        sections = Array(repeating: .initial, count: length)
    }

    func movingHead(direction: Direction) -> Rope {
        var rope = self
        rope.sections[0].moveHead(direction: direction)
        for i in 1..<sections.count {
            rope.sections[i].head = rope.sections[i-1].tail
            rope.sections[i].followTail()
        }
        return rope
    }
}

private enum Direction: String, CustomStringConvertible {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
    var description: String { rawValue }
}

private func parseInstruction(line: String) throws -> [Direction] {
    let parts = line.components(separatedBy: .whitespaces)
    guard let direction = Direction(rawValue: parts[0]),
          let times = Int(parts[1]) else {
        throw ParseError()
    }
    return Array(repeating: direction, count: times)
}

private func debugState(_ state: Rope, width: Int, height: Int) -> String {
    (0..<height).reversed().map { y in
        (0..<width).map { x in
            if state.head.x == x && state.head.y == y {
                return "H"
            } else if state.tail.x == x && state.tail.y == y {
                return "T"
            } else {
                return "."
            }
        }
        .joined()
    }
    .joined(separator: "\n")
}

private func debugStates(_ states: [Rope]) -> String {
    let width = states.map(\.head.x).max()! + 1
    let height = states.map(\.head.y).max()! + 1

    return states.map { debugState($0, width: width, height: height)}
        .joined(separator: "\n\n")
}

struct Day9: Solution {
    let day = 9
    
    func solve(final: Bool, partTwo: Bool) throws -> String {
        let ropeLength = partTwo ? 9 : 1
        let rope = Rope(length: ropeLength)

        let input: [String]
        if partTwo && !final {
            input = try loadInput(name: "day9-test2").components(separatedBy: "\n")
        } else {
            input = try lines(final: final)
        }

        let states = try input
            .flatMap(parseInstruction(line:))
            .reduce([rope], { previousStates, direction in
                let currentState = previousStates.last!
                let newState = currentState.movingHead(direction: direction)
                return previousStates + [newState]
            })

//        print(debugStates(states))

        return Set(states.map(\.tail))
            .count
            .description
    }
}

