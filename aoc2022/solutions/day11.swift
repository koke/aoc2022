import Foundation

private let doDebug = false
private func debug(_ str: String) {
    guard doDebug else { return }
    print(str)
}

struct Day11: Solution {
    let day = 11

    enum Operation {
        case add(Int)
        case multiply(Int)
        case square
    }

    struct Monkey {
        var items: [Int]
        let operation: Operation
        let testDivisibleBy: Int
        let testTrue: Int
        let testFalse: Int
        var inspectCount = 0

        func doOperation(item: Int) -> Int {
            let message: String
            let result: Int
            switch operation {
            case .add(let value):
                message = "    Worry level increases by \(value) to"
                result = item + value
            case .multiply(let value):
                message = "    Worry level is multiplied by \(value) to"
                result = item * value
            case .square:
                message = "    Worry level is multiplied by itself to"
                result = item * item
            }
            debug("\(message) \(result)")
            return result
        }

        func doTest(item: Int) -> Int {
            let testResult = (item % testDivisibleBy) == 0
            debug("    Current worry level is \(testResult ? "" : "not ")divisible by \(testDivisibleBy)")
            return testResult ? testTrue : testFalse
        }

        static func parse(string: String) throws -> Monkey {
            var startingItems: [Int]?
            var operation: Operation?
            var testDivisibleBy: Int?
            var testTrue: Int?
            var testFalse: Int?

            for line in string.components(separatedBy: .newlines) {
                let parts = line.trimmingCharacters(in: .whitespaces).components(separatedBy: ": ")
                if parts[0] == "Starting items" {
                    startingItems = parts[1].components(separatedBy: ", ").map { Int($0)! }
                } else if parts[0] == "Operation" {
                    if parts[1] == "new = old * old" {
                        operation = .square
                    } else if parts[1].starts(with: "new = old * ") {
                        let value = Int(parts[1].components(separatedBy: "* ")[1])!
                        operation = .multiply(value)
                    } else if parts[1].starts(with: "new = old + ") {
                        let value = Int(parts[1].components(separatedBy: "+ ")[1])!
                        operation = .add(value)
                    } else {
                        throw ParseError()
                    }
                } else if parts[0] == "Test" {
                    testDivisibleBy = Int(parts[1].components(separatedBy: .whitespaces).last!)!
                } else if parts[0] == "If true" {
                    testTrue = Int(parts[1].components(separatedBy: .whitespaces).last!)!
                } else if parts[0] == "If false" {
                    testFalse = Int(parts[1].components(separatedBy: .whitespaces).last!)!
                } else if parts[0].starts(with: "Monkey ") {
                    continue
                } else {
                    throw ParseError()
                }
            }
            guard let startingItems,
                  let operation,
                  let testDivisibleBy,
                  let testTrue,
                  let testFalse else {
                throw ParseError()
            }

            return Monkey(
                items: startingItems,
                operation: operation,
                testDivisibleBy: testDivisibleBy,
                testTrue: testTrue,
                testFalse: testFalse)
        }
    }

    func round(number: Int, monkeys: inout [Monkey], reduceWorry: Bool) {
        debug("Round \(number)")
        for i in 0..<monkeys.count {
            debug("Monkey \(i):")
            while !monkeys[i].items.isEmpty {
                let item = monkeys[i].items.removeFirst()
                monkeys[i].inspectCount += 1
                debug("  Monkey inspects an item with a worry level of \(item)")
                var newItem = monkeys[i].doOperation(item: item)
                if reduceWorry {
                    newItem /= 3
                    debug("    Monkey gets bored with item. Worry level is divided by 3 to \(newItem).")
                }
                let targetMonkey = monkeys[i].doTest(item: newItem)
                debug("    Item with worry level \(newItem) is thrown to monkey \(targetMonkey).")
                monkeys[targetMonkey].items.append(newItem)
            }
        }
    }

    func reduceWorry(monkeys: inout [Monkey], modulo: Int) {
        for i in 0..<monkeys.count {
            monkeys[i].items = monkeys[i].items.map({ item in
                let result = item.remainderReportingOverflow(dividingBy: modulo)
                guard !result.overflow else {
                    fatalError()
                }
                return result.partialValue
            })
        }
    }
    
    func solve(final: Bool, partTwo: Bool) throws -> String {
        var monkeys = try input(final: final)
            .components(separatedBy: "\n\n")
            .map(Monkey.parse(string:))

        let modulo = monkeys
            .map(\.testDivisibleBy)
            .reduce(1, *)

        let totalRounds = partTwo ? 10000 : 20
        for roundNumber in 1...totalRounds {
            round(number: roundNumber, monkeys: &monkeys, reduceWorry: !partTwo)
            debug("After round \(roundNumber), the monkeys are holding items with these worry levels:")
            for item in monkeys.enumerated() {
                debug("Monkey \(item.offset): \(item.element.items))")
            }
            reduceWorry(monkeys: &monkeys, modulo: modulo)
        }

        for item in monkeys.enumerated() {
            debug("Monkey \(item.offset) inspected items \(item.element.inspectCount) times")
        }

        return monkeys
            .sorted(by: { a, b in a.inspectCount > b.inspectCount })
            .prefix(2)
            .map(\.inspectCount)
            .reduce(1, *)
            .description
    }
}

