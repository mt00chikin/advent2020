//: [Previous](@previous)

import Foundation

struct BoardingPass {
    let seatColumn: Int
    let seatRow: Int
    var seatId: Int { seatRow * 8 + seatColumn }

    init?(passString: String) {
        guard passString.count == 10 else { return nil }
        // Calculate the seat column using the first 7 characters of the string
        let rowCode = passString.prefix(7)
        var rowBinaryString: String = ""
        rowCode.forEach { $0 == "F" ? rowBinaryString.append("0") : rowBinaryString.append("1") }
        seatRow = Int(rowBinaryString, radix: 2)!

        // Calculate the seat row using the final 3 characters of the string
        let columnCode = passString.suffix(3)
        var columnBinaryString: String = ""
        columnCode.forEach { $0 == "L" ? columnBinaryString.append("0") : columnBinaryString.append("1") }
        seatColumn = Int(columnBinaryString, radix: 2)!
    }
}

let knownMinSeat = "FFFFFFFLLL"
let minSeat = BoardingPass(passString: knownMinSeat)
minSeat?.seatColumn
minSeat?.seatRow

let knownMaxSeat = "BBBBBBBRRR"
let maxSeat = BoardingPass(passString: knownMaxSeat)
maxSeat?.seatColumn
maxSeat?.seatRow

let path = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: path)!

let raw = String(data: data, encoding: .utf8)!

let rawPasses = raw.components(separatedBy: .newlines)
let passes = rawPasses.compactMap { BoardingPass(passString: $0) }

// MARK: - Part One

let seatIds = passes.map { $0.seatId }
let maximumSeatId = seatIds.max()

// MARK: - Part Two

let sortedSeatIds = seatIds.sorted()
var mySeatId: Int?
for (index, seatId) in sortedSeatIds.enumerated() {
    if sortedSeatIds[index + 1] != seatId + 1 {
        mySeatId = seatId + 1
        break
    }
}
mySeatId
