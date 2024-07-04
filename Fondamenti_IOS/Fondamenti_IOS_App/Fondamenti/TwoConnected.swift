//
//  TwoConnected.swift
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
func is_valid_degree_sequence2(degree_sequence: [Int]) -> Bool {
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
 * - Returns: An array representing the degree sequence after construction, or nil if construction fails.
 */
func havel_hakimi_construction2(degree_sequence: [Int]) -> [Int]? {
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
func is_connected_graph2(graph: [[Int]]) -> Bool {
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
func build_graph_from_degrees2(degree_sequence: [Int]) -> [[Int]]? {
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
 * Finds the cut vertices (articulation points) of a graph.
 *
 * - Parameter graph: The adjacency list of the graph.
 * - Returns: An array of integers representing the cut vertices.
 */
func find_cut_vertices(graph: [[Int]]) -> [Int] {
    let n = graph.count
    var disc = [Int](repeating: -1, count: n)
    var low = [Int](repeating: -1, count: n)
    var parent = [Int](repeating: -1, count: n)
    var ap = [Bool](repeating: false, count: n)
    var time = 0
    
    /**
     * Depth-First Search (DFS) utility for finding cut vertices.
     *
     * - Parameter u: The current vertex being explored.
     */
    func dfs(u: Int) {
        var children = 0
        disc[u] = time
        low[u] = time
        time += 1
        
        for v in graph[u] {
            if disc[v] == -1 {
                parent[v] = u
                children += 1
                dfs(u: v)
                low[u] = min(low[u], low[v])
                if parent[u] == -1 && children > 1 {
                    ap[u] = true
                }
                if parent[u] != -1 && low[v] >= disc[u] {
                    ap[u] = true
                }
            } else if v != parent[u] {
                low[u] = min(low[u], disc[v])
            }
        }
    }
    
    for i in 0..<n {
        if disc[i] == -1 {
            dfs(u: i)
        }
    }
    
    return ap.enumerated().compactMap { $1 ? $0 : nil }
}

/**
 * Checks if a degree sequence represents a 2-connected graph.
 *
 * - Parameter degree_sequence: The degree sequence as an array of integers.
 * - Returns: A boolean indicating if the degree sequence represents a 2-connected graph.
 */
func is_2_connected(degree_sequence: [Int]) -> Bool {
    _ = degree_sequence.count
    
    if degree_sequence.contains(where: { $0 < 2 }) {
        return false
    }
    
    if degree_sequence.reduce(0, +) % 2 != 0 {
        return false
    }
    
    if !is_valid_degree_sequence2(degree_sequence: degree_sequence) {
        return false
    }
    
    guard let graph = build_graph_from_degrees2(degree_sequence: degree_sequence) else {
        return false
    }
    
    if !is_connected_graph2(graph: graph) {
        return false
    }
    
    if !find_cut_vertices(graph: graph).isEmpty {
        return false
    }
    
    return true
}
