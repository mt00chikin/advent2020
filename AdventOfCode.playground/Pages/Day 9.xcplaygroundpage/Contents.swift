import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let raw = String(data: data, encoding: .utf8)!

let input = raw.components(separatedBy: .newlines).compactMap { Int($0) }

let preambleLength = 25

// MARK: - Part 1

var solution: (index: Int, value: Int)!

let startIndex = preambleLength
for index in startIndex..<input.count {
    let lookbackIndex = index - preambleLength
    let preamble = input[lookbackIndex..<index]

    var sums: Set<Int> = []
    for i in preamble.startIndex..<preamble.endIndex {
        for j in preamble.startIndex..<preamble.endIndex {
            let firstValue = preamble[i]
            let secondValue = preamble[j]

            guard i != j, firstValue != secondValue else {
                continue
            }

            sums.insert(firstValue + secondValue)
        }
    }

    guard sums.contains(input[index]) else {
        solution = (index, input[index])
        break
    }
}

print("Part one solution is \(solution)")

// MARK: - Part 2

let prefix = input.prefix(upTo: solution.index)
var contiguousRange: ClosedRange<Int>!
for i in prefix.startIndex..<prefix.endIndex {
    var sum = prefix[i]
    for j in i+1..<prefix.endIndex {
        sum = sum + prefix[j]
        if sum == solution.value {
            contiguousRange = i...j
            break
        } else if sum > solution.value {
            break
        }
    }
}

let solutionArray = input[contiguousRange]
let partTwoSolution = solutionArray.min()! + solutionArray.max()!
print("Part two solution is \(partTwoSolution)")
