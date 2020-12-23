import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let input = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

//let input = """
//departure location: 45-535 or 550-961
//departure station: 45-278 or 294-974
//departure platform: 46-121 or 138-965
//departure track: 38-149 or 173-949
//departure date: 34-223 or 248-957
//departure time: 32-64 or 79-952
//arrival location: 49-879 or 905-968
//arrival station: 47-306 or 323-973
//arrival platform: 46-823 or 834-971
//arrival track: 30-464 or 486-963
//class: 40-350 or 372-965
//duration: 47-414 or 423-950
//price: 45-507 or 526-956
//route: 42-779 or 799-970
//row: 26-865 or 872-955
//seat: 43-724 or 739-970
//train: 25-914 or 926-958
//type: 33-205 or 218-965
//wagon: 43-101 or 118-951
//zone: 45-844 or 858-970
//
//your ticket:
//173,191,61,199,101,179,257,79,193,223,139,97,83,197,251,53,89,149,181,59
//
//nearby tickets:
//949,764,551,379,767,144,556,835,999,591,653,872,198,825,690,527,260,396,873,333
//"""

let scanner = Scanner(string: input)
var delimiterSet = CharacterSet()
delimiterSet.formUnion(.whitespacesAndNewlines)
delimiterSet.insert(":")
scanner.charactersToBeSkipped = delimiterSet

typealias TicketRestrictions = (minRange: ClosedRange<Int>, maxRange: ClosedRange<Int>)

struct Ticket: CustomStringConvertible {
    let values: [Int]
    
    /// Returns any invalid ticket numbers
    func validate(ranges: [TicketRestrictions]) -> [Int] {
        let invalidTickets = values.filter { value in
            var isInvalid = true
            for i in 0..<ranges.count {
                let range = ranges[i]
                if range.minRange.contains(value) || range.maxRange.contains(value) {
                    isInvalid = false
                    break
                }
            }
            return isInvalid
        }
        return invalidTickets
    }
    
    var description: String {
        values.map(String.init).joined(separator: ",")
    }
}

struct TicketGroup: Hashable {
    var title: String
    var restrictions: TicketRestrictions
    
    static func == (lhs: TicketGroup, rhs: TicketGroup) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

var groups: [TicketGroup] = []
var restrictions: [TicketRestrictions]!

var ticketGroups: [String: TicketRestrictions] = [:]
var myTicket: Ticket?
var nearbyTickets: [Ticket] = []

func buildValidSeatSet(input: String) {
    while !scanner.isAtEnd {
        let ticketSection = scanner.scanUpToString(":")!
        guard let range = scanner.scanUpToString("\n") else { continue }
        
        if range.contains(" or ") {
            let components = range.components(separatedBy: " or ")
            let minRangeComponents = components[0].components(separatedBy: "-").compactMap(Int.init)
            let maxRangeComponents = components[1].components(separatedBy: "-").compactMap(Int.init)
            
            let restrictions = (minRangeComponents[0]...minRangeComponents[1], maxRangeComponents[0]...maxRangeComponents[1])
            let group = TicketGroup(title: ticketSection,
                                    restrictions: restrictions)
            groups.append(group)
            
            ticketGroups[ticketSection] = (minRangeComponents[0]...minRangeComponents[1], maxRangeComponents[0]...maxRangeComponents[1])
        } else {
            switch ticketSection {
            case "your ticket":
                myTicket = Ticket(values: range.components(separatedBy: ",").compactMap(Int.init))
            case "nearby tickets":
                nearbyTickets.append(Ticket(values: range.components(separatedBy: ",").compactMap(Int.init)))
                while !scanner.isAtEnd {
                    if let tickets = scanner.scanUpToString("\n") {
                        nearbyTickets.append(Ticket(values: tickets.components(separatedBy: ",").compactMap(Int.init)))
                    }
                }
            default: break
            }
        }
    }
}

func findInvalidSeats() -> [Int] {
    var invalidValues: [Int] = []
    nearbyTickets.forEach { ticket in
        invalidValues.append(contentsOf: ticket.validate(ranges: restrictions))
    }
    return invalidValues
}

func indexRestrictions() {
    restrictions = groups.map { $0.restrictions }
}

buildValidSeatSet(input: input)
indexRestrictions()

// MARK: - Part 1

let invalidSeats = findInvalidSeats()
print("Total seats \(nearbyTickets.count). Invalid seats \(invalidSeats.count)")
let sum = invalidSeats.reduce(0, +)

// MARK: - Part 2

let validTickets = nearbyTickets.filter{ $0.validate(ranges: restrictions).isEmpty }
print("There are \(validTickets.count) valid tickets")

var map: [Int: Set<String>] = [:]
validTickets.forEach { ticket in
    for (index, value) in ticket.values.enumerated() {
        let possibleGroups = groups.filter {
            $0.restrictions.minRange.contains(value) || $0.restrictions.maxRange.contains(value)
        }.map { $0.title }
        
        var set = map[index, default: []]
        if set.isEmpty {
            set = Set(possibleGroups)
        } else {
            set = set.intersection(Set(possibleGroups))
        }
        map[index] = set
    }
}

var assignedTitles: Set<String> = []
var guesses: [Int: Set<String>] = [:]
map.sorted(by: { $0.value.count < $1.value.count }).forEach { key, value in
    guesses[key] = value.subtracting(assignedTitles)
    print("Guess for \(key): \(value.subtracting(assignedTitles))")
    assignedTitles.formUnion(value)
}

let solution = [17,15,2,19,6,16].compactMap { myTicket?.values[$0] }.reduce(1, *)
print("Solution \(solution)")
