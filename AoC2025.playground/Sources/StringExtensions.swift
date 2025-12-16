//
//  StringExtensions.swift
//  
//
//  Created by Brett Chapin on 12/15/25.
//

public extension String {
    func numberOfOccurrences(of substring: String) -> Int {
        guard !substring.isEmpty else { return 0 }
        let components = components(separatedBy: substring)
        let filteredComponents = components.filter(\.isEmpty)
        return (components.count == filteredComponents.count) ? components.count - 1 : 0
    }
}
