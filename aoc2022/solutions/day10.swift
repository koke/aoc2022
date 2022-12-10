import Foundation

struct Day10: Solution {
    let day = 10

    enum Instruction {
        case noop
        case addx(Int)

        init(_ string: String) throws {
            if string == "noop" {
                self = .noop
            } else if string.starts(with: "addx"),
                      let value = Int(string.components(separatedBy: " ")[1]) {
                self = .addx(value)
            } else {
                throw ParseError()
            }
        }

        func execute(x: Int) -> [Int] {
            switch self {
            case .noop:
                return [x]
            case .addx(let value):
                return [x, x + value]
            }
        }
    }

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let history = try lines(final: final)
            .map(Instruction.init)
            .reduce([1,1], { registerHistory, instruction in
                registerHistory + instruction.execute(x: registerHistory.last!)
            })

        if partTwo {
            return "\n" + (1...240)
                .map { cycle in
                    let column = (cycle % 40) - 1
                    let spriteMiddle = history[cycle]
                    if spriteMiddle == column || spriteMiddle - 1 == column || spriteMiddle + 1 == column {
                        return "#"
                    } else {
                        return "."
                    }
                }
                .chunked(into: 40)
                .map { $0.joined() }
                .joined(separator: "\n")
        } else {
            let cycles = [20, 60, 100, 140, 180, 220]
            return cycles
                .map { cycle in
                    history[cycle] * cycle
                }
                .sum()
                .description
        }
    }
}

