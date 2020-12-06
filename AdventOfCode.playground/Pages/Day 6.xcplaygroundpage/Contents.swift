import Foundation

let example = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

// MARK: - Example

let exampleAnswergroups = example.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
var exampleSum = 0
exampleAnswergroups.forEach { answergroup in
    let filteredString = answergroup.replacingOccurrences(of: "\n", with: "")
    exampleSum = exampleSum + Set(filteredString).count
}
print(exampleSum)

// PART 2

var examplePartTwoSum = 0
exampleAnswergroups.forEach { answergroup in
    let questionees = answergroup.components(separatedBy: .newlines)
    let answers = questionees.map { Set($0) }

    var commonAnswers: Set<String.Element>?
    answers.forEach {
        guard commonAnswers != nil else {
            commonAnswers = $0
            return
        }

        commonAnswers = commonAnswers?.intersection($0)
    }
    examplePartTwoSum = examplePartTwoSum + (commonAnswers?.count ?? 0)
}
print(examplePartTwoSum)

// MARK: - Implementation

let path = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: path)!

let raw = String(data: data, encoding: .utf8)!

let answergroups = raw.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
var sum = 0
answergroups.forEach { answergroup in
    let filteredString = answergroup.replacingOccurrences(of: "\n", with: "")
    sum = sum + Set(filteredString).count
}
print(sum)

// PART 2

var partTwoSum = 0
answergroups.forEach { answergroup in
    let questionees = answergroup.components(separatedBy: .newlines)
    let answers = questionees.map { Set($0) }

    var commonAnswers: Set<String.Element>?
    answers.forEach {
        guard commonAnswers != nil else {
            commonAnswers = $0
            return
        }

        commonAnswers = commonAnswers?.intersection($0)
    }
    partTwoSum = partTwoSum + (commonAnswers?.count ?? 0)
}
print(partTwoSum)
