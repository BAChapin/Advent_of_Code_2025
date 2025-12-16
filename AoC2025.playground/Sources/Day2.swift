//
//  Day2.swift
//  
//
//  Created by Brett Chapin on 12/15/25.
//

public struct Day2: SolutionEngine {
    // Day 2: Gift Shop
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day2")
            let lines = input.split(separator: ",")
            self.lines = lines.map { String($0) }
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        var invalidIds: Int = 0
        let ranges = lines.map { $0.split(separator: "-") }.compactMap { createRange(from: $0) }
        
        ranges.forEach {
            invalidIds += $0.reduce(0) { total, number in
                return total + (isValid(id: number) ? 0 : number)
            }
        }
        
//        print(String(repeating: "-", count: 80))
//        print("Adding up all the invalid IDs produces \(invalidIds)")
//        print(String(repeating: "-", count: 80))
    }
    
    public func partTwo() {
        var invalidIds: Int = 0
        let ranges = lines.map { $0.split(separator: "-") }.compactMap { createRange(from: $0) }
        
        ranges.forEach {
            invalidIds += $0.reduce(0) { total, number in
                return total + (isValidExpanded(id: number) ? 0 : number)
            }
        }
        
//        print(String(repeating: "-", count: 80))
//        print("Adding up all the invalid IDs produces \(invalidIds)")
//        print(String(repeating: "-", count: 80))
    }
    
    private func createRange(from substrings: [String.SubSequence]) -> ClosedRange<Int>? {
        guard let start = substrings.first, let end = substrings.last?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        guard let startInt = Int(start), let endInt = Int(end) else { return nil }
        
        return startInt...endInt
    }
    
    private func isValid(id: Int) -> Bool {
        let string = String(id)
        let midpoint = string.count / 2
        let firstStart = string.startIndex
        let firstEnd = string.index(string.startIndex, offsetBy: midpoint)
        let secondEnd = string.endIndex
        
        let firstSubstring = string[firstStart..<firstEnd]
        let secondSubstring = string[firstEnd..<secondEnd]
        
        return firstSubstring != secondSubstring
    }
    
    private func isValidExpanded(id: Int) -> Bool {
        let string = String(id)
        let midpoint = string.count / 2
        let firstIndex = string.startIndex
        
        if string.count == 1 {
            return true
        }
        
        for offset in 1...midpoint {
            let secondIndex = string.index(firstIndex, offsetBy: offset)
            let substring = string[firstIndex..<secondIndex]
            let count = string.numberOfOccurrences(of: String(substring))
            if count > 1 {
                return false
            }
        }
        
        return true
    }
}
