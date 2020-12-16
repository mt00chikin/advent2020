import Foundation

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let input = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
let components = input.components(separatedBy: .newlines)
let earliestDepartureTime: Int = Int(components[0])!
let routes = components[1].components(separatedBy: ",")
print(routes)

// MARK: - Part 1

let inServiceRoutes = routes.compactMap { Int($0) }

var firstAvailableRoute: Int?
var departureTime: Int = earliestDepartureTime

repeat {
    firstAvailableRoute = inServiceRoutes.first(where: { departureTime % $0 == 0 })
    guard firstAvailableRoute != nil else {
        departureTime += 1
        continue
    }
} while firstAvailableRoute == nil

print("Found a route")

departureTime
firstAvailableRoute

let waitTime = (departureTime - earliestDepartureTime)
let partOneSolution = firstAvailableRoute! * waitTime

// MARK: - Part 2

var routesWithOffsets: [(route: Int, offset: Int)] = []
for (index, route) in routes.enumerated() {
    guard route != "x" else { continue }
    routesWithOffsets.append((Int(route)!, index))
}
print(routesWithOffsets)

var timestamp = 100000000000000
var actualTimestamp: Int?
repeat {
    let filteredRoutes = routesWithOffsets.filter { (timestamp + $0.offset) % $0.route == 0 }
    guard filteredRoutes.count == routesWithOffsets.count else {
        // All our routes don't line up, increment the timestamp and try again
        timestamp = timestamp + 1
        continue
    }
    
    actualTimestamp = timestamp
} while actualTimestamp == nil

actualTimestamp
