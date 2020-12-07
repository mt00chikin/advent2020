import Foundation

// My solution was horrible and failed miserably.
// I stole this from Jake Foster so that I could spend some time with it and wrap my head further around how it handles recursion

public struct Bag {
    public typealias Content = (count: Int, color: String)

    public let color: String
    // Dictionary of the bags that are contained by the current bag
    public let contents: [Content]

    public init(color: String, contents: [Content]) {
        self.color = color
        self.contents = contents
    }
}

public struct BagRegistry {
    public typealias Color = String

    private let bagByColor: [Color: Bag]
    private let parentsByChild: [Color: Set<Color>]

    public var shinyGoldBag: Bag { retrieveBag(withColor: "shiny gold")! }

    public init(bags: [Bag]) {
        bagByColor = bags.reduce(into: [:]) { result, value in
            result[value.color] = value
        }
        parentsByChild = Self.calculateParentsByChild(for: Array(bagByColor.values))
    }

    private static func calculateParentsByChild(for bags: [Bag]) -> [Color: Set<Color>] {
        var result = [Color: Set<Color>]()
        for parent in bags {
            for (_, childColor) in parent.contents {
                result[childColor, default: []].insert(parent.color)
            }
        }
        return result
    }

    public func retrieveParents(of child: Bag) -> [Bag] {
        parentsByChild[child.color]?.compactMap { bagByColor[$0] } ?? []
    }

    public func retrieveBag(withColor color: Color) -> Bag? {
        bagByColor[color]
    }
}
