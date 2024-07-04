//
//  HamiltonianCycle.swift
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
func is_valid_degree_sequence(_ degree_sequence: [Int]) -> Bool {
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
 * Constructs a graph using the Havel-Hakimi algorithm from a degree sequence.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A 2D array representing the adjacency list of the graph, or nil if construction fails.
 */
func havel_hakimi_construction(_ degree_sequence: [Int]) -> [[Int]]? {
    let degree_sequence = degree_sequence.sorted(by: >)
    let n = degree_sequence.count
    var graph = [[Int]](repeating: [Int](), count: n)
    
    var degree_sequence_with_indices = degree_sequence.enumerated().map { ($0.element, $0.offset) }
    
    while !degree_sequence_with_indices.isEmpty {
        degree_sequence_with_indices.sort { $0.0 > $1.0 }
        if degree_sequence_with_indices[0].0 == 0 {
            break
        }
        
        let v = degree_sequence_with_indices.removeFirst()
        let d = v.0
        let v_index = v.1
        
        if d > degree_sequence_with_indices.count {
            return nil
        }
        
        for i in 0..<d {
            let u = degree_sequence_with_indices[i]
            let u_degree = u.0 - 1
            let u_index = u.1
            graph[v_index].append(u_index)
            graph[u_index].append(v_index)
            degree_sequence_with_indices[i] = (u_degree, u_index)
        }
    }
    
    return graph
}

/**
 * Checks if the given path forms a Hamiltonian cycle in the graph.
 *
 * - Parameters:
 *   - graph: The adjacency list of the graph.
 *   - path: The path to check.
 * - Returns: A boolean indicating if the path forms a Hamiltonian cycle.
 */
func is_hamiltonian_cycle(graph: [[Int]], path: [Int]) -> Bool {
    let n = graph.count
    return path.count == n && graph[path[0]].contains(path[n - 1])
}

/**
 * Utility function for finding a Hamiltonian cycle.
 *
 * - Parameters:
 *   - graph: The adjacency list of the graph.
 *   - path: The current path being explored.
 *   - position: The current position in the path.
 * - Returns: A boolean indicating if a Hamiltonian cycle is found.
 */
func hamiltonian_cycle_util(graph: [[Int]], path: inout [Int], position: Int) -> Bool {
    let n = graph.count
    if position == n {
        return is_hamiltonian_cycle(graph: graph, path: path)
    }
    
    for v in 1..<n {
        if is_safe(v: v, graph: graph, path: path, position: position) {
            path[position] = v
            if hamiltonian_cycle_util(graph: graph, path: &path, position: position + 1) {
                return true
            }
            path[position] = -1
        }
    }
    
    return false
}

/**
 * Checks if it is safe to add a vertex to the Hamiltonian path.
 *
 * - Parameters:
 *   - v: The vertex to add.
 *   - graph: The adjacency list of the graph.
 *   - path: The current path.
 *   - position: The current position in the path.
 * - Returns: A boolean indicating if it is safe to add the vertex.
 */
func is_safe(v: Int, graph: [[Int]], path: [Int], position: Int) -> Bool {
    return graph[path[position - 1]].contains(v) && !path.contains(v)
}

/**
 * Finds a Hamiltonian cycle in the graph.
 *
 * - Parameter graph: The adjacency list of the graph.
 * - Returns: An array representing the Hamiltonian cycle, or nil if no cycle is found.
 */
func hamiltonian_cycle(graph: [[Int]]) -> [Int]? {
    let n = graph.count
    var path = [Int](repeating: -1, count: n)
    path[0] = 0
    
    if !hamiltonian_cycle_util(graph: graph, path: &path, position: 1) {
        return nil
    }
    return path
}

/**
 * Checks if a degree sequence contains a Hamiltonian cycle.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A boolean indicating if the graph contains a Hamiltonian cycle.
 */
func contains_hamiltonian_cycle(degree_sequence: [Int]) -> Bool {
    if !is_valid_degree_sequence(degree_sequence) {
        return false
    }
    
    guard let graph = havel_hakimi_construction(degree_sequence) else {
        return false
    }
    
    if hamiltonian_cycle(graph: graph) == nil {
        return false
    }
    
    return true
}
