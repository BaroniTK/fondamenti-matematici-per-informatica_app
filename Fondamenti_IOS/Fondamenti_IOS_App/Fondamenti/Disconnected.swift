//
//  Disconnected.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import Foundation

/**
 * Checks if a degree sequence is valid.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A boolean indicating if the degree sequence is valid.
 */
func is_valid_degree_sequence(degree_sequence: [Int]) -> Bool {
    let degree_sequence = degree_sequence.sorted(by: >)
    let n = degree_sequence.count
    
    for k in 1...n {
        let left_side = degree_sequence.prefix(k).reduce(0, +)
        let right_side = k * (k - 1) + degree_sequence.dropFirst(k).reduce(0) { $0 + min($1, k) }
        if left_side > right_side {
            return false
        }
    }
    return true
}

/**
 * Constructs a degree sequence using the Havel-Hakimi algorithm.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: An array representing the degree sequence after construction, or nil if construction fails.
 */
func havel_hakimi_construction(degree_sequence: [Int]) -> [Int]? {
    var degree_sequence = degree_sequence.sorted(by: >)
    while !degree_sequence.isEmpty && degree_sequence[0] == 0 {
        degree_sequence.removeFirst()
    }
    if degree_sequence.isEmpty {
        return []
    }
    
    while !degree_sequence.isEmpty {
        let d = degree_sequence.removeFirst()
        if d > degree_sequence.count {
            return nil
        }
        for i in 0..<d {
            degree_sequence[i] -= 1
            if degree_sequence[i] < 0 {
                return nil
            }
        }
        degree_sequence.sort(by: >)
    }
    return degree_sequence
}

/**
 * Checks if a graph is connected.
 *
 * - Parameter graph: The adjacency list of the graph.
 * - Returns: A boolean indicating if the graph is connected.
 */
func is_connected_graph(graph: [[Int]]) -> Bool {
    let n = graph.count
    var visited = [Bool](repeating: false, count: n)
    var stack = [0]
    visited[0] = true
    var count = 1
    
    while !stack.isEmpty {
        let node = stack.removeLast()
        for neighbor in graph[node] {
            if !visited[neighbor] {
                visited[neighbor] = true
                stack.append(neighbor)
                count += 1
            }
        }
    }
    
    return count == n
}

/**
 * Builds a graph from a degree sequence.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A 2D array representing the adjacency list of the graph, or nil if construction fails.
 */
func build_graph_from_degrees(degree_sequence: [Int]) -> [[Int]]? {
    let n = degree_sequence.count
    var graph = [[Int]](repeating: [Int](), count: n)
    var degree_sequence = degree_sequence.enumerated().map { ($0.element, $0.offset) }
    degree_sequence.sort { $0.0 > $1.0 }
    
    while !degree_sequence.isEmpty && degree_sequence[0].0 > 0 {
        let (d, node) = degree_sequence.removeFirst()
        if d > degree_sequence.count {
            return nil
        }
        for i in 0..<d {
            let neighbor = degree_sequence[i].1
            graph[node].append(neighbor)
            graph[neighbor].append(node)
            degree_sequence[i].0 -= 1
        }
        degree_sequence.sort { $0.0 > $1.0 }
    }
    
    return graph
}

/**
 * Checks if a graph is disconnected based on its degree sequence.
 *
 * - Parameter score: The degree sequence as an array of integers.
 * - Returns: A boolean indicating if the graph is disconnected.
 */
func is_graph_disconnected(score: [Int]) -> Bool {
    if score.allSatisfy({ $0 == 0 }) {
        return true
    }
    
    if score.contains(where: { $0 >= score.count }) {
        return true
    }
    
    if !is_valid_degree_sequence(degree_sequence: score) {
        return true
    }
    
    guard let graph = build_graph_from_degrees(degree_sequence: score) else {
        return true
    }
    
    return !is_connected_graph(graph: graph)
}
