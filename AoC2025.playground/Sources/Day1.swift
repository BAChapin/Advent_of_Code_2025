//
//  Day1.swift
//  
//
//  Created by Brett Chapin on 12/3/25.
//

public struct Day1: SolutionEngine {
    // Day 1: Secret Entrance
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day1")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        print(String(repeating: "-", count: 80))
        var dial = SafeDial()
        
        lines.forEach { line in
            if let (direction, rotation) = try? inputKeyAndValue(line) {
                if direction.lowercased() == "r" {
                    dial.turnRight(points: rotation)
                } else if direction.lowercased() == "l" {
                    dial.turnLeft(points: rotation)
                }
            }
        }
        
        if let answer = dial.visitedPositions[0] {
            print(" - The door's password is: ", answer)
        }
        print(String(repeating: "-", count: 80))
    }
    
    public func partTwo() {
        print(String(repeating: "-", count: 80))
        var dial = SecureDial()
        
        lines.forEach { line in
            if let (direction, rotation) = try? inputKeyAndValue(line) {
                if direction.lowercased() == "r" {
                    dial.turnRight(points: rotation)
                } else if direction.lowercased() == "l" {
                    dial.turnLeft(points: rotation)
                }
            }
        }
        
        print(" - The secure door's password is: ", dial.timesZeroCrossed)
        
        print(String(repeating: "-", count: 80))
    }
    
    private func inputKeyAndValue(_ line: String) throws -> (direction: String, rotation: Int) {
        let startIndex = line.index(after: line.startIndex)
        let lastIndex = line.endIndex
        
        let direction = String(line[line.startIndex])
        let rotation = line[startIndex..<lastIndex]
        
        guard let rotationValue = Int(rotation) else {
            throw Day1Error.unableToParseInput
        }
        
        return (direction, rotationValue)
    }
    
}

extension Day1 {
    protocol DialPassword {
        var currentPosition: Int { get }
        
        mutating func turnRight(points: Int)
        mutating func turnLeft(points: Int)
    }
    
    struct SafeDial: DialPassword {
        private let _defaultPosition: Int = 50
        private let _maxValue: Int = 100
        var currentPosition: Int
        var visitedPositions: [Int : Int] = [:]
        
        init(startPosition: Int? = nil) {
            self.currentPosition = startPosition ?? _defaultPosition
        }
        
        mutating func turnRight(points: Int) {
            // +
            let restartPoint = _maxValue - currentPosition
            let truePointChange = points % _maxValue
            if truePointChange >= restartPoint {
                currentPosition = truePointChange - restartPoint
            } else {
                currentPosition += truePointChange
            }
            updateVisitedPositions()
        }
        
        mutating func turnLeft(points: Int) {
            // -
            let truePointChange = points % _maxValue
            if truePointChange > currentPosition {
                let changeValue = currentPosition - truePointChange
                currentPosition = _maxValue + changeValue
            } else {
                currentPosition -= truePointChange
            }
            updateVisitedPositions()
        }
        
        mutating func updateVisitedPositions() {
            if let current = visitedPositions[currentPosition] {
                visitedPositions[currentPosition] = current + 1
            } else {
                visitedPositions[currentPosition] = 1
            }
        }
    }
    
    struct SecureDial: DialPassword {
        private let _defaultPosition: Int = 50
        private let _maxValue: Int = 100
        var currentPosition: Int
        var timesZeroCrossed: Int = 0
        
        init(startPosition: Int? = nil) {
            self.currentPosition = startPosition ?? _defaultPosition
        }
        
        mutating func turnRight(points: Int) {
            // +
            let restartPoint = _maxValue - currentPosition
            let truePointChange = points % _maxValue
            let numberOfRotations: Int = (points / _maxValue)
            if truePointChange >= restartPoint {
                let previousPosition = currentPosition
                currentPosition = truePointChange - restartPoint
                timesZeroCrossed += (previousPosition != 0) ? 1 : 0
            } else {
                currentPosition += truePointChange
            }
            timesZeroCrossed += numberOfRotations
        }
        
        mutating func turnLeft(points: Int) {
            // -
            let truePointChange = points % _maxValue
            let numberOfRotations: Int = (points / _maxValue)
            if truePointChange > currentPosition {
                let changeValue = currentPosition - truePointChange
                let previousPosition = currentPosition
                currentPosition = _maxValue + changeValue
                timesZeroCrossed += (previousPosition != 0) ? 1 : 0
            } else {
                currentPosition -= truePointChange
                if currentPosition == 0 {
                    timesZeroCrossed += 1
                }
            }
            timesZeroCrossed += numberOfRotations
        }
        
        
    }
}

extension Day1 {
    enum Day1Error: Error {
        case unableToParseInput
    }
}
