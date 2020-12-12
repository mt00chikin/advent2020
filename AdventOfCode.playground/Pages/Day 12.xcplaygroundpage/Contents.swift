import Foundation

struct NavigationInstruction: CustomDebugStringConvertible {
    enum RotationDirection {
        case left
        case right
    }
    
    enum Heading: Int {
        case east = 90
        case south = 180
        case west = 270
        case north = 0
    }
    
    enum Operation {
        case traverse(Heading)
        case rotate(RotationDirection)
        case forward
    }
    
    let operation: Operation
    let value: Int
    
    init?(string: String) {
        let prefix = string.first
        let value = string.dropFirst()
        
        switch prefix {
        case "N":
            operation = .traverse(.north)
        case "S":
            operation = .traverse(.south)
        case "E":
            operation = .traverse(.east)
        case "W":
            operation = .traverse(.west)
        case "L":
            operation = .rotate(.left)
        case "R":
            operation = .rotate(.right)
        case "F":
            operation = .forward
        default:
            return nil
        }
        
        self.value = Int(value)!
    }
    
    var debugDescription: String { "\(operation): \(value)" }
}

struct Coordinate: CustomStringConvertible {
    var x: Int
    var y: Int
    
    static let zero: Coordinate = Coordinate(x: 0, y: 0)
    
    mutating func move(by distance: Coordinate) {
        x = x + distance.x
        y = y + distance.y
    }
    
    func distance(to coordinate: Coordinate) -> Coordinate {
        return Coordinate(x: coordinate.x - x, y: coordinate.y - y)
    }
    
    var manhattanDistance: Int { abs(x) + abs(y) }
    
    var description: String { "(\(x),\(y))" }
}

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let input = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
let instructions = input.components(separatedBy: .newlines).compactMap { NavigationInstruction(string: $0) }

// MARK: - Part 1

var currentHeading: NavigationInstruction.Heading = .east
var currentCoordinate: Coordinate = .zero

func traverse(distance: Int, heading: NavigationInstruction.Heading) {
    switch heading {
    case .north:
        currentCoordinate.y = currentCoordinate.y + distance
    case .south:
        currentCoordinate.y = currentCoordinate.y - distance
    case .east:
        currentCoordinate.x = currentCoordinate.x + distance
    case .west:
        currentCoordinate.x = currentCoordinate.x - distance
    }
}

func updateHeading(angle: Int, direction: NavigationInstruction.RotationDirection) {
    let newHeading: Int
    switch direction {
    case .left:
        newHeading = abs((currentHeading.rawValue + 360 - angle) % 360)
    case .right:
        newHeading = abs((currentHeading.rawValue + angle) % 360)
    }
    currentHeading = NavigationInstruction.Heading(rawValue: newHeading)!
}

instructions.forEach { instruction in
    switch instruction.operation {
    case .traverse(let heading):
        traverse(distance: instruction.value, heading: heading)
    case .rotate(let direction):
        updateHeading(angle: instruction.value, direction: direction)
    case .forward:
        traverse(distance: instruction.value, heading: currentHeading)
    }
}

let partOneSolution = currentCoordinate.manhattanDistance

// MARK: - Part 2

// Reset heading and coordinate
currentHeading = .east
currentCoordinate = .zero

var waypoint: Coordinate = Coordinate(x: 10, y: 1)

instructions.forEach { instruction in
    switch instruction.operation {
    case .traverse(let heading):
        // Update waypoint position
        let offset: Coordinate
        switch heading {
        case .east:
            offset = Coordinate(x: instruction.value, y: 0)
        case .south:
            offset = Coordinate(x: 0, y: -instruction.value)
        case .west:
            offset = Coordinate(x: -instruction.value, y: 0)
        case .north:
            offset = Coordinate(x: 0, y: instruction.value)
        }
        waypoint.move(by: offset)
    case .rotate(let direction):
        var distanceToWaypoint = currentCoordinate.distance(to: waypoint)
        // Rotate waypoint about the ship
        switch direction {
        // All of the following statements assume a problem statement where the waypoint is rotated only in 90 degree intervals. Any other value would fail here
        case .left:
            switch instruction.value {
            case 90:
                distanceToWaypoint = Coordinate(x: -distanceToWaypoint.y, y: distanceToWaypoint.x)
            case 180:
                distanceToWaypoint = Coordinate(x: -distanceToWaypoint.x, y: -distanceToWaypoint.y)
            case 270:
                distanceToWaypoint = Coordinate(x: distanceToWaypoint.y, y: -distanceToWaypoint.x)
            default:
                break
            }
        case .right:
            switch instruction.value {
            case 90:
                distanceToWaypoint = Coordinate(x: distanceToWaypoint.y, y: -distanceToWaypoint.x)
            case 180:
                distanceToWaypoint = Coordinate(x: -distanceToWaypoint.x, y: -distanceToWaypoint.y)
            case 270:
                distanceToWaypoint = Coordinate(x: -distanceToWaypoint.y, y: distanceToWaypoint.x)
            default:
                break
            }
        }
        
        waypoint = Coordinate(x: currentCoordinate.x + distanceToWaypoint.x, y: currentCoordinate.y + distanceToWaypoint.y)
    case .forward:
        // Move the ship to the waypoint
        let distanceToWaypoint = currentCoordinate.distance(to: waypoint)
        let totalTraversal = Coordinate(x: distanceToWaypoint.x * instruction.value, y: distanceToWaypoint.y * instruction.value)
        currentCoordinate.move(by: totalTraversal)
        
        // Update the waypoint to the same relative position
        waypoint = Coordinate(x: currentCoordinate.x + distanceToWaypoint.x, y: currentCoordinate.y + distanceToWaypoint.y)
    }
}

let partTwoSolution = currentCoordinate.manhattanDistance
