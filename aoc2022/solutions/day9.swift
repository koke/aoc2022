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

private struct State: CustomStringConvertible {
    var head: Position
    var tail: Position

    static let initial: Self = .init(head: .initial, tail: .initial)

    func movingHead(direction: Direction) -> State {
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

private func debugState(_ state: State, width: Int, height: Int) -> String {
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

private func debugStates(_ states: [State]) -> String {
    let width = states.map(\.head.x).max()! + 1
    let height = states.map(\.head.y).max()! + 1

    return states.map { debugState($0, width: width, height: height)}
        .joined(separator: "\n\n")
}

struct Day9: Solution {
    let day = 9
    
    func solve(final: Bool, partTwo: Bool) throws -> String {
        guard !partTwo else {
            throw NotImplemented()
        }
        let states = try lines(final: final)
            .flatMap(parseInstruction(line:))
            .reduce([State.initial], { previousStates, direction in
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

