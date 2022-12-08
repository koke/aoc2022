import Foundation

typealias Tree = (x: Int, y: Int, height: Int)

func existsHigherTreeNorth(tree: Tree, forest: [Tree]) -> Bool {
    forest.contains { other in
        tree.x == other.x && other.y < tree.y && other.height >= tree.height
    }
}
func existsHigherTreeSouth(tree: Tree, forest: [Tree]) -> Bool {
    forest.contains { other in
        tree.x == other.x && other.y > tree.y && other.height >= tree.height
    }
}
func existsHigherTreeWest(tree: Tree, forest: [Tree]) -> Bool {
    forest.contains { other in
        tree.y == other.y && other.x < tree.x && other.height >= tree.height
    }
}
func existsHigherTreeEast(tree: Tree, forest: [Tree]) -> Bool {
    forest.contains { other in
        tree.y == other.y && other.x > tree.x && other.height >= tree.height
    }
}

func treeIsVisible(tree: Tree, forest: [Tree]) -> Bool {
    !existsHigherTreeNorth(tree: tree, forest: forest)
    || !existsHigherTreeSouth(tree: tree, forest: forest)
    || !existsHigherTreeWest(tree: tree, forest: forest)
    || !existsHigherTreeEast(tree: tree, forest: forest)
}

func visibleTreesNorth(tree: Tree, forest: [Tree]) -> Int {
    let otherTrees = forest
        .filter { other in
            other.x == tree.x && other.y < tree.y
        }
        .sorted(by: { a, b in a.y > b.y })
    var count = 0
    for other in otherTrees {
        count += 1
        if other.height >= tree.height {
            break
        }
    }
    return count
}

func visibleTreesSouth(tree: Tree, forest: [Tree]) -> Int {
    let otherTrees = forest
        .filter { other in
            other.x == tree.x && other.y > tree.y
        }
        .sorted(by: { a, b in a.y < b.y })
    var count = 0
    for other in otherTrees {
        count += 1
        if other.height >= tree.height {
            break
        }
    }
    return count
}

func visibleTreesWest(tree: Tree, forest: [Tree]) -> Int {
    let otherTrees = forest
        .filter { other in
            other.y == tree.y && other.x < tree.x
        }
        .sorted(by: { a, b in a.x > b.x })
    var count = 0
    for other in otherTrees {
        count += 1
        if other.height >= tree.height {
            break
        }
    }
    return count
}

func visibleTreesEast(tree: Tree, forest: [Tree]) -> Int {
    let otherTrees = forest
        .filter { other in
            other.y == tree.y && other.x > tree.x
        }
        .sorted(by: { a, b in a.x < b.x })
    var count = 0
    for other in otherTrees {
        count += 1
        if other.height >= tree.height {
            break
        }
    }
    return count
}

func scenicScore(tree: Tree, forest: [Tree]) -> Int {
    let north = visibleTreesNorth(tree: tree, forest: forest)
    let south = visibleTreesSouth(tree: tree, forest: forest)
    let west = visibleTreesWest(tree: tree, forest: forest)
    let east = visibleTreesEast(tree: tree, forest: forest)

//    print("(\(tree.x), \(tree.y))[\(tree.height)] = \(north) * \(south) * \(west) * \(east) = \(north*south*east*west)")

    return north * south * west * east
}

struct Day8: Solution {
    let day = 8

    func solve(final: Bool, partTwo: Bool) throws -> String {
        let forest = try lines(final: final)
            .enumerated()
            .map { line in
                line.element
                    .enumerated()
                    .map { column in
                        Tree(x: column.offset, y: line.offset, height: Int(String(column.element))!)
                    }
            }
        let flatForest = forest
            .flatMap { $0 }

        if partTwo {
            return flatForest
                .map { scenicScore(tree: $0, forest: flatForest) }
                .max()!
                .description
        } else {
            return flatForest
                .filter { treeIsVisible(tree: $0, forest: flatForest) }
                .count
                .description
        }
    }
}

