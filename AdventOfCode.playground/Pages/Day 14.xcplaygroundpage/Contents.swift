import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let input = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

let operations = input.components(separatedBy: .newlines)

func memoryAddress(string: String) -> Int? {
    var address: Int?
    let pattern = #"mem\[(\d+)\]"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(string.startIndex..<string.endIndex,
                        in: string)
    regex.enumerateMatches(in: string,
                           options: [],
                           range: range) { match, _, stop in
        guard let match = match else {
            return
        }
        
        if match.numberOfRanges == 2 {
            if let firstCaptureRange = Range(match.range(at: 1), in: string) {
                address = Int(string[firstCaptureRange])
                stop.pointee = true
            }
        }
    }
    
    return address
}

var currentMask: String?
//var registers: [Int: Int] = [:]

// MARK: - Part 1

func v1Decode(operations: [String]) -> [Int: Int] {
    var registers: [Int: Int] = [:]
    operations.forEach { operation in
        let components = operation.components(separatedBy: " = ")
        if components[0] == "mask" {
            // Create new mask
            currentMask = components[1]
        } else {
            guard let address = memoryAddress(string: components[0]), let mask = currentMask else {
                return
            }
            let decimalValue = Int(components[1])!
            let binaryString = String(decimalValue, radix: 2)
            let padding = String(repeating: "0", count: 36 - binaryString.count)
            let paddedBinaryString = padding + binaryString
            let zipped = zip(paddedBinaryString, mask)
            let maskedCharacters = zipped.map { (binaryStringCharacter, maskCharacter) -> Character in
                if maskCharacter == "X" { return binaryStringCharacter }
                else { return maskCharacter }
            }
            let maskedValue = String(maskedCharacters)
            registers[address] = Int(maskedValue, radix: 2)
        }
    }
    return registers
}

let sum = v1Decode(operations: operations).values.reduce(0, +)

// MARK: - Part 2

func v2Decode(operations: [String]) -> [Int: Int] {
    var registers: [Int: Int] = [:]
    operations.forEach { operation in
        let components = operation.components(separatedBy: " = ")
        if components[0] == "mask" {
            // Create new mask
            currentMask = components[1]
        } else {
            guard let address = memoryAddress(string: components[0]), let mask = currentMask else {
                return
            }
            
//            print("Masking memory address \(address)")
            let binaryString = String(address, radix: 2)
            let padding = String(repeating: "0", count: 36 - binaryString.count)
            let paddedBinaryString = padding + binaryString
            let zipped = zip(paddedBinaryString, mask)
            let maskedMemoryAddress = zipped.map { (binaryStringCharacter, maskCharacter) -> Character in
                if maskCharacter == "0" { return binaryStringCharacter }
                else if maskCharacter == "1" { return maskCharacter }
                else { return maskCharacter }
            }
            let maskedValue = String(maskedMemoryAddress)
//            print(maskedValue)
            let floatingBits = maskedValue.filter { $0 == "X" }.count
//            print("Floating bits \(floatingBits)")
            let permutations = Int(pow(Double(2), Double(floatingBits)))
//            print("\(permutations) permutations")
            var memoryAddresses: [Int] = []
            for i in 0..<permutations {
                let binary = String(i, radix: 2)
                let padding = String(repeating: "0", count: floatingBits - binary.count)
//                print(padding + binary)
                let paddedBinary = padding + binary
                let bitArray = paddedBinary.map { Int(String($0))! }
                var address: String = ""
                var bitIndex: Int = 0
                maskedValue.forEach {
                    guard $0 == "X" else {
                        address.append($0)
                        return
                    }
                    
                    address.append(String(bitArray[bitIndex]))
                    bitIndex += 1
                }
//                print("Updated address \(address)")
                memoryAddresses.append(Int(address, radix: 2)!)
            }
//            print("All memory addresses to update \(memoryAddresses)")
            
            // Build array of all possible memory addresses
            let decimalValue = Int(components[1])!
            memoryAddresses.forEach { registers[$0] = decimalValue }
        }
    }
    return registers
}

v2Decode(operations: operations).values.reduce(0, +)
