import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let raw = String(data: data, encoding: .utf8)!

var input = raw.components(separatedBy: .newlines).compactMap { Int($0) }.sorted()
// Assume a starting joltage of 0 at the beginning of our chain
input.insert(0, at: 0)

var currentJoltage = 0
var oneJoltDifferences: Int = 0
var threeJoltDifferences: Int = 1 // Assume a single joltage jump of 3 at the very end of the chain

for i in 0..<input.count {
    let difference = input[i] - currentJoltage
    if difference == 1 {
        oneJoltDifferences = oneJoltDifferences + 1
    } else if difference == 3 {
        threeJoltDifferences = threeJoltDifferences + 1
    }
    currentJoltage = input[i]
}

let partOneSolution = oneJoltDifferences * threeJoltDifferences

// MARK: - Part 2

var permutations: [Int: Int] = [:]
let finalAdapterValue = input.last!
// Assume a single permutation for the final 3 jolt jump from adapter to the charging outlet
permutations[finalAdapterValue] = 1
// Iterate over the adapters, doing a lookback at each to figure out how many adapters are available and how many distinct permutations each has available
let reversedInput: [Int] = input.reversed()
for i in (1..<input.count) {
    let currentValue = reversedInput[i]
    // Look back at the previous adapters, keeping only eligible ones (<3 jolt difference)
    let availableAdapters = reversedInput.prefix(upTo: i).filter { $0 - currentValue <= 3 }
    // Add all the possible permutations for each available adapter, that's how many we have available to us at this level
    permutations[currentValue] = availableAdapters.compactMap { permutations[$0] }.reduce(0, +)
}

// How many distinct permutations are there from adapter at position 0?
let partTwoSolution = permutations[0]
