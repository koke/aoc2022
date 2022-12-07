import Foundation

struct File {
    let name: String
    let size: Int
}

class Directory {
    let name: String
    let parent: Directory?
    var directories: [Directory] = []
    var files: [File] = []
    init(name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
    }

    var size: Int {
        return directories.map(\.size).sum() + files.map(\.size).sum()
    }

    var traverse: [Directory] {
        return [self] + self.directories.flatMap(\.traverse)
    }
}

struct Day7: Solution {
    let day = 7

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let root = Directory(name: "/")
        var current = root
        let commands = try input(final: final)
            .components(separatedBy: "$ ")
            .map { $0.trimmingCharacters(in: .newlines) }
            .filter { !$0.isEmpty }

        for command in commands {
            switch command.prefix(2) {
            case "cd":
                let dir = command.dropFirst(3)
                if dir == "/" {
                    break
                } else if dir == ".." {
                    current = current.parent!
                } else {
                    current = current.directories.first(where: { $0.name == dir })!
                }
            case "ls":
                command
                    .components(separatedBy: .newlines)
                    .dropFirst()
                    .forEach { list in
                        let components = list.components(separatedBy: .whitespaces)
                        if components[0] == "dir" {
                            current.directories.append(Directory(name: components[1], parent: current))
                        } else {
                            current.files.append(File(name: components[1], size: Int(components[0])!))
                        }
                    }
            default:
                throw ParseError()
            }
        }

        let sizes = root.traverse.map { return (name: $0.name, size: $0.size) }
        if partTwo {
            let totalSpace = 70000000
            let requiredSpace = 30000000
            let currentUsage = root.size
            let currentFree = totalSpace - currentUsage
            let amountToFreeUp = requiredSpace - currentFree

            return sizes
                .filter { $0.size >= amountToFreeUp }
                .map(\.size)
                .sorted()
                .first!
                .description
        } else {
            return sizes
                .filter { $0.size <= 100000 }
                .map(\.size)
                .sum()
                .description
        }
    }
}
