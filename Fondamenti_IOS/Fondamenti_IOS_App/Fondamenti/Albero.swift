//
//  Albero.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import Foundation

/**
 * Checks if a degree sequence represents a tree.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A boolean indicating if the degree sequence represents a tree.
 */
func is_tree(degree_sequence: [Int]) -> Bool {
    var degree_sequence = degree_sequence
    let n = degree_sequence.count
    
    // Step 1: Check if the sum of the degrees is 2*(n-1)
    if degree_sequence.reduce(0, +) != 2 * (n - 1) {
        return false
    }
    
    // Step 2: Ensure there is at least one vertex
    if n < 1 {
        return false
    }
    
    // Step 3: Sort the degree sequence in non-increasing order
    degree_sequence.sort(by: >)
    
    // Step 4: Check if the sequence is a graphical sequence using the Havel-Hakimi algorithm
    while !degree_sequence.isEmpty {
        degree_sequence = degree_sequence.filter { $0 > 0 }
        
        if degree_sequence.isEmpty {
            return true
        }
        
        degree_sequence.sort(by: >)
        let d = degree_sequence.removeFirst()
        
        if d > degree_sequence.count {
            return false
        }
        
        for i in 0..<d {
            degree_sequence[i] -= 1
        }
        
        if degree_sequence.contains(where: { $0 < 0 }) {
            return false
        }
    }
    
    return true
}
