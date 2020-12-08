import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let rawExample = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
let rules = rawExample.components(separatedBy: .newlines)

let bags = rules.map { rule -> Bag in
    let components = rule.components(separatedBy: " bags contain ")
    let bagColor = components[0]
    let contentString = components[1].trimmingCharacters(in: .punctuationCharacters)
    let possibleContents = contentString.components(separatedBy: ", ")

    let pattern = "^(\\d+) (.*) bag|s"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    var contents: [Bag.Content] = []
    possibleContents.forEach { bagContents in
        let range = NSRange(bagContents.startIndex..<bagContents.endIndex, in: bagContents)
        regex.enumerateMatches(in: bagContents, options: [], range: range) { match, _, stop in
            guard let match = match else { return }

            if match.numberOfRanges == 3 {
                if let firstCaptureRange = Range(match.range(at: 1), in: bagContents), let secondCaptureRange = Range(match.range(at: 2), in: bagContents) {
                    let containedBagColor = String(bagContents[secondCaptureRange])
                    let numberOfContainedBags = Int(bagContents[firstCaptureRange])!
                    contents.append(Bag.Content(numberOfContainedBags, containedBagColor))
                }
            }
        }
    }

    return Bag(color: bagColor, contents: contents)
}

print("Created \(bags.count) bags")

let registry = BagRegistry(bags: bags)

// MARK: - Part 1

var ancestors: Set<String> = []

func findAncestors(bag: Bag) {
    registry.retrieveParents(of: bag).forEach {
        ancestors.insert($0.color)
        findAncestors(bag: $0)
    }
}

findAncestors(bag: registry.shinyGoldBag)
print("Number of unique bags \(ancestors.count)")

// MARK: - Part 2

func countDescendants(bag: Bag) -> Int {
    bag.contents.reduce(0) { result, content -> Int in
        guard let child = registry.retrieveBag(withColor: content.color) else { return result }
        print("Child \(child)")
        return result + content.count * (countDescendants(bag: child) + 1)
    }
}

let count = countDescendants(bag: registry.shinyGoldBag)
print("Total bags \(count)")
