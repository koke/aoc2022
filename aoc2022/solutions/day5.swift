import Foundation
import RegexBuilder

typealias Stack = [String]
typealias Stacks = [String: Stack]

struct Instruction {
    let amount: Int
    let from: String
    let to: String

    static func parse(_ input: String) throws -> Self {
        let regex = Regex {
            "move "

            Capture {
                OneOrMore(.digit)
            } transform: { d in
                Int(d)
            }

            " from "

            Capture {
                OneOrMore(.digit)
            } transform: { d in
                String(d)
            }


            " to "

            Capture {
                OneOrMore(.digit)
            } transform: { d in
                String(d)
            }
        }

        guard let match = try regex.wholeMatch(in: input) else {
            throw ParseError()
        }
        let (_, amount, from, to) = match.output
        guard let amount else { throw ParseError() }
        return Self.init(amount: amount, from: from, to: to)
    }

    func applySingle(stacks: Stacks) throws -> Stacks {
        var stacks = stacks
        for _ in 1...amount {
            guard var sourceStack = stacks[from],
                  var targetStack = stacks[to],
                  let item = sourceStack.popLast() else {
                throw ParseError()
            }
            targetStack.append(item)
            stacks[from] = sourceStack
            stacks[to] = targetStack
        }
        return stacks
    }

    func applyMultiple(stacks: Stacks) throws -> Stacks {
        var stacks = stacks
        guard let sourceStack = stacks[from],
              var targetStack = stacks[to] else {
            throw ParseError()
        }
        let items = sourceStack.suffix(amount)
        targetStack += items
        stacks[from] = sourceStack.dropLast(amount)
        stacks[to] = targetStack
        return stacks
    }
}

func parseStacks(_ input: String) throws -> Stacks {
    let lines = input.components(separatedBy: "\n")
    guard let stackNames = lines.last else {
        throw ParseError()
    }

    let stackLines = lines.dropLast(1)
    let labeledLines = stackLines.map { line in
        zip(stackNames, line)
            .filter { $0.0 != " " }
            .filter { $0.1 != " " }
    }

    return Dictionary(grouping: labeledLines.flatMap({$0}), by: { String($0.0) } )
        .mapValues {
            Array($0
                .map { String($0.1) }
                .reversed())
        }
}

func parseInstructions(_ input: String) throws -> [Instruction] {
    try input
        .components(separatedBy: "\n")
        .map(Instruction.parse(_:))
}

struct Day5: Solution {
    let day = 5

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let parts = try input(final: final)
            .components(separatedBy: "\n\n")

        var stacks = try parseStacks(parts[0])
        let instructions = try parseInstructions(parts[1])

        for instruction in instructions {
//            print("Stacks: \(stacks)")
//            print("Instruction: \(instruction)")
            if partTwo {
                stacks = try instruction.applyMultiple(stacks: stacks)
            } else {
                stacks = try instruction.applySingle(stacks: stacks)
            }
        }
//        print("Stacks: \(stacks)")
        return stacks.sorted(by: { $0.0 < $1.0 })
            .map(\.value)
            .map({ $0.last! })
            .joined()
    }
}
