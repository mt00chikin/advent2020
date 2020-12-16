import Foundation

let exampleInput = [3,1,2]

let puzzleInput = [2,1,10,11,0,6]

func predictNumber(at turn: Int, input: [Int]) -> Int {
    var numberStore: [Int: Int] = [:]
    var nextNumber: Int = 0
    
    for (index, startingNumber) in input.enumerated() {
        numberStore[startingNumber] = index
    }
    
    (1..<turn).forEach { currentTurn in
        guard currentTurn > input.count else {
            numberStore[input[currentTurn - 1]] = currentTurn
            return
        }
        
        let lastNumber = nextNumber
        
        if let lastTurn = numberStore[lastNumber] {
            nextNumber = currentTurn - lastTurn
        } else {
            // The number hasn't been mentioned before
            nextNumber = 0
        }
        
        numberStore[lastNumber] = currentTurn
    }

    return nextNumber
}

let partOneSolution = predictNumber(at: 2020, input: puzzleInput)

let partTwoSolution = predictNumber(at: 30000000, input: puzzleInput)
