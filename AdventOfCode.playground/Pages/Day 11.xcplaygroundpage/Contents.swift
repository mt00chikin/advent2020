import Foundation
import UIKit

struct Seat: Hashable {
    enum State: Character {
        case empty = "L"
        case occupied = "#"
        case floor = "."
    }

    var state: Seat.State
    var location: IndexPath

    // Only use location to identify a seat, state is mutable
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
}

class SeatMap {
    var seatGrid: [[Seat.State]]
    var adjacentSeats: [IndexPath: [IndexPath]] = [:]

    init(seatGrid: [[Seat.State]]) {
        self.seatGrid = seatGrid

        buildAdjacentSeatMap(from: seatGrid)
    }

    func buildAdjacentSeatMap(from grid: [[Seat.State]]) {
        //  Iterate over all seats in the grid and build our relationship for adjacent seats
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let indexPath = IndexPath(row: i, section: j)
                
                let minRow = max(0, i - 1)
                let maxRow = min(grid.count - 1, i + 1)

                // There is definitely a more efficient way to convert a two dimensional array to all its possible values
                let minColumn = max(0, j - 1)
                let maxColumn = min(grid[i].count - 1, j + 1)
                
                var adjacentIndexPaths: [IndexPath] = []
                for row in minRow...maxRow {
                    for column in minColumn...maxColumn {
                        let adjacentIndexPath = IndexPath(row: row, section: column)
                        guard adjacentIndexPath != indexPath else { continue }
                        adjacentIndexPaths.append(adjacentIndexPath)
                    }
                }
                adjacentSeats[indexPath] = adjacentIndexPaths
            }
        }
    }

    func seat(at indexPath: IndexPath) -> Seat.State? {
        return seatGrid[indexPath.row][indexPath.section]
    }

    /// Iterates over the current grid of seats and updates their state as necessary
    /// - Returns: Set containing all of the seats whose state was modified
    func updateSeatStatus() -> Set<IndexPath> {
        var changedSeats: Set<IndexPath> = []

        var seatGrid = self.seatGrid
        for i in 0..<seatGrid.count {
            for j in 0..<seatGrid[i].count {
                let indexPath = IndexPath(row: i, section: j)

                guard let seat = seat(at: indexPath) else { continue }
                // Don't consider floor seats
                guard seat != .floor else { continue }

                guard let adjacentSeatIndexPaths = adjacentSeats[indexPath] else { continue }
                let adjacentSeats = adjacentSeatIndexPaths.compactMap { return self.seat(at: $0) }
                let occupiedAdjacentSeats = adjacentSeats.filter { $0 == .occupied }
                
                if occupiedAdjacentSeats.count >= 4 && seat == .occupied {
                    seatGrid[indexPath.row][indexPath.section] = .empty
                    changedSeats.insert(indexPath)
                } else if occupiedAdjacentSeats.isEmpty && seat == .empty {
                    seatGrid[indexPath.row][indexPath.section] = .occupied
                    changedSeats.insert(indexPath)
                }
            }
        }
        // Update the final seat grid
        self.seatGrid = seatGrid

        return changedSeats
    }

    var occupiedSeats: [Seat.State] {
        return seatGrid.flatMap { $0 }.filter { $0 == .occupied }
    }

    var gridString: String {
        return seatGrid.map { $0.map { String($0.rawValue) }.joined() }.joined(separator: "\n")
    }
}

let inputPath = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: inputPath)!

let raw = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

var grid: [[Seat.State]] = raw.components(separatedBy: .newlines).map { return $0.compactMap { Seat.State(rawValue: $0) } }

let seatMap = SeatMap(seatGrid: grid)

seatMap.occupiedSeats.count

var changedSeats: Set<IndexPath>
var count = 0
repeat {
    changedSeats = seatMap.updateSeatStatus()
    count = count + 1
} while !changedSeats.isEmpty

print("Finished updating seats after \(count) iterations. Final seat grid: \n \(seatMap.gridString)")
print("Total occupied seats: \(seatMap.occupiedSeats.count)")
