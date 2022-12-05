import Foundation

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

struct Day3: Solution {
    let day = 3

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let lines = try lines(final: final)

        let items: [Character]
        if partTwo {
            items = lines.chunked(into: 3)
                .map(findCommonItem(elves:))
        } else {
            items = lines
                .map(splitRucksack(_:))
                .map(findWrongItem(compartments:))
        }

        return items
            .map(itemPriority(_:))
            .sum()
            .description
    }
}

func day3(final: Bool) throws -> Int {
    let input = try loadInput(day: 3, final: final)

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


    return input
        .components(separatedBy: "\n")
        .chunked(into: 3)
        .map(findCommonItem(elves:))
        .map(debug(prefix: "commonItem"))
        .map(itemPriority(_:))
        .map(debug(prefix: "priority"))
        .sum()
}
