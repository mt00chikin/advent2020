import Foundation

enum Operation: Equatable {
    case accumulate(Int)
    case jump(Int)
    case noOperation(Int)

    static func == (lhs: Operation, rhs: Operation) -> Bool {
        switch (lhs, rhs) {
        case (.accumulate, .accumulate):
            return true
        case (.jump, .jump):
            return true
        case (.noOperation, .noOperation):
            return true
        default: return false
        }
    }
}

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let raw = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
let operations = raw.components(separatedBy: .newlines)

let operationSet: [Operation] = operations.map {
    let components = $0.components(separatedBy: .whitespaces)
    let value = Int(components[1])!
    switch components[0] {
    case "acc":
        return .accumulate(value)
    case "jmp":
        return .jump(value)
    default:
        return .noOperation(value)
    }
}

print("Created \(operationSet.count) operations")

// The global value stored by the program
var value: Int = 0
var currentIndex: Int = 0
var operatedIndices: Set<Int> = []

enum OperationError: Error {
    case repeatedInvocation
}

func performOperations(operationSet: [Operation]) throws {
    repeat {
        let operation = operationSet[currentIndex]
        operatedIndices.insert(currentIndex)

        var nextIndex: Int
        switch operation {
        case .accumulate(let increment):
            value = value + increment
            nextIndex = currentIndex + 1
        case .jump(let offset):
            nextIndex = currentIndex + offset
        default:
            nextIndex = currentIndex + 1
        }

        // If we've already executed the next index, break the loop
        guard !operatedIndices.contains(nextIndex) else {
            currentIndex = operationSet.count
            throw OperationError.repeatedInvocation
        }

        currentIndex = nextIndex
    } while currentIndex < operationSet.count
}

// MARK: - Part 1

do {
    try performOperations(operationSet: operationSet)
    value
} catch {
    print("Performed \(operatedIndices.count) operations before terminating")
    print("Final value before infinite loop \(value)")
}

// MARK: - Part 2

func resetCounters() {
    value = 0
    currentIndex = 0
    operatedIndices.removeAll()
}

for i in 0..<operationSet.count {
    // Reset all our values
    resetCounters()

    let operation = operationSet[i]

    var modifiedOperationSet = operationSet
    let newOperation: Operation
    switch operation {
    case .accumulate:
        continue
    case .jump(let value):
        newOperation = .noOperation(value)
    case .noOperation(let value):
        newOperation = .jump(value)
    }
    modifiedOperationSet[i] = newOperation

    do {
        try performOperations(operationSet: modifiedOperationSet)
        print("Changing operation at index \(i) did the trick")
        print("Successfully reached the end of our operation set!")
        print("Final value is: \(value)")
    } catch {
        // No op
    }
}

