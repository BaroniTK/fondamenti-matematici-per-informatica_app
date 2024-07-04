//
//  Isomorphisms.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import SwiftUI

/**
 * View for checking isomorphisms between multiple graphs.
 */
struct Isomorphisms: View {
    @ObservedObject var isoData: IsoData
    @State private var showModal: Bool = false
    @State private var resultString: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Primo grafo:")
                    .font(.headline)
                
                TextField("g1: x1-x2,x2-x3,...", text: $isoData.graph1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Group {
                Text("Secondo grafo:")
                    .font(.headline)
                
                TextField("g2: x1-x2,x2-x3,...", text: $isoData.graph2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Group {
                Text("Terzo grafo:")
                    .font(.headline)
                
                TextField("g3: x1-x2,x2-x3,...", text: $isoData.graph3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer() // Spacer to push the button down
            
            HStack {
                Spacer()
                Button(action: {
                    // Start the modal view passing the values of the text fields
                    resultString = performGraphChecks(graph1: isoData.graph1, graph2: isoData.graph2, graph3: isoData.graph3)
                    showModal = true
                }) {
                    Text("Calcola")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding()
        .navigationTitle("Isomorfismi")
        .sheet(isPresented: $showModal) {
            // Pass the values of the text fields to the modal view
            ModalView(resultString: $resultString, showModal: $showModal)
        }
    }
    
    /**
     * Perform checks between the given graphs.
     *
     * - Parameters:
     *   - graph1: The first graph as a string.
     *   - graph2: The second graph as a string.
     *   - graph3: The third graph as a string.
     * - Returns: A string describing the results of the checks.
     */
    func performGraphChecks(graph1: String, graph2: String, graph3: String) -> String {
        var result = ""
        let graphs = [graph1, graph2, graph3].filter { !$0.isEmpty }
        
        let graphPairs = [(0, 1), (1, 2), (0, 2)].filter { $0.0 < graphs.count && $0.1 < graphs.count }
        
        for (i, j) in graphPairs {
            result += "Controlli tra grafo \(i + 1) e grafo \(j + 1):\n"
            result += checkGraphPair(graph1: graphs[i], graph2: graphs[j])
            result += "\n"
        }
        
        return result
    }
    
    /**
     * Checks a pair of graphs for isomorphism.
     *
     * - Parameters:
     *   - graph1: The first graph as a string.
     *   - graph2: The second graph as a string.
     * - Returns: A string describing the results of the checks.
     */
    func checkGraphPair(graph1: String, graph2: String) -> String {
        let g1 = parseGraph(graphString: graph1)
        let g2 = parseGraph(graphString: graph2)
        let g1String = parseGraphToString(graphString: graph1)
        let g2String = parseGraphToString(graphString: graph2)
        
        var result = ""
        
        if graphScore(graph: g1String) == graphScore(graph: g2String) {
            result += "Controllo 1 verificato\n"
        } else {
            result += "Controllo 1 non verificato\n"
            return result
        }
        
        if isHamiltonian(graph: g1String) == isHamiltonian(graph: g2String) {
            result += "Controllo 2 verificato\n"
            result += "Controllo 3 verificato\n"
            result += "Controllo 4 verificato\n"
        } else {
            if is2Connected(graph: g1String) == is2Connected(graph: g2String) {
                result += "Controllo 2 verificato\n"
                result += "Controllo 3 verificato\n"
            } else {
                if isConnected(graph: g1String) == isConnected(graph: g2String) {
                    result += "Controllo 2 verificato\n"
                } else {
                    result += "Controllo 2 non verificato\n"
                    return result
                }
                result += "Controllo 3 non verificato\n"
                return result
            }
            result += "Controllo 4 non verificato\n"
            return result
        }
        
        if countDegreeThreeVertices(graph: g1String) == countDegreeThreeVertices(graph: g2String) {
            result += "Controllo 5 verificato\n"
        } else {
            result += "Controllo 5 non verificato\n"
            return result
        }
        
        if maxDegreeVertexNeighborsCheck(graph1: g1String, graph2: g2String) {
            result += "Controllo 6 verificato\n"
            if let isomorphismResult = definisciIsomorfismoCasualeEVerificaArchi(g1: g1, g2: g2) {
                result += isomorphismResult
            } else {
                result += "I grafi non sono isomorfi."
            }
            
        } else {
            result += "Controllo 6 non verificato\n"
        }
        
        return result
    }
    
    /**
     * Parses a graph string into a dictionary representation.
     *
     * - Parameter graphString: The graph string.
     * - Returns: A dictionary representing the graph.
     */
    func parseGraph(graphString: String) -> [Int: [Int]] {
        var graph = [Int: [Int]]()
        let edges = graphString.split(separator: ",")
        for edge in edges {
            let vertices = edge.split(separator: "-")
            if vertices.count == 2 {
                if let v1 = Int(vertices[0]), let v2 = Int(vertices[1]) {
                    graph[v1, default: []].append(v2)
                    graph[v2, default: []].append(v1)
                }
            }
        }
        return graph
    }
    
    /**
     * Parses a graph string into a dictionary representation with string keys.
     *
     * - Parameter graphString: The graph string.
     * - Returns: A dictionary representing the graph.
     */
    func parseGraphToString(graphString: String) -> [String: [String]] {
        var graph = [String: [String]]()
        let edges = graphString.split(separator: ",")
        for edge in edges {
            let vertices = edge.split(separator: "-")
            if vertices.count == 2 {
                let v1 = String(vertices[0])
                let v2 = String(vertices[1])
                graph[v1, default: []].append(v2)
                graph[v2, default: []].append(v1)
            }
        }
        return graph
    }
    
    /**
     * Calculates the score of a graph.
     *
     * - Parameter graph: The graph as a dictionary.
     * - Returns: An array of integers representing the degree of each vertex.
     */
    func graphScore(graph: [String: [String]]) -> [Int] {
        return graph.values.map { $0.count }.sorted()
    }
    
    /**
     * Checks if a graph is connected.
     *
     * - Parameter graph: The graph as a dictionary.
     * - Returns: A boolean indicating if the graph is connected.
     */
    func isConnected(graph: [String: [String]]) -> Bool {
        guard let start = graph.keys.first else { return true }
        var visited = Set<String>()
        var stack = [start]
        
        while !stack.isEmpty {
            let node = stack.removeLast()
            if !visited.contains(node) {
                visited.insert(node)
                stack.append(contentsOf: graph[node] ?? [])
            }
        }
        
        return visited.count == graph.count
    }
    
    /**
     * Checks if a graph is 2-connected.
     *
     * - Parameter graph: The graph as a dictionary.
     * - Returns: A boolean indicating if the graph is 2-connected.
     */
    func is2Connected(graph: [String: [String]]) -> Bool {
        let nodes = Array(graph.keys)
        for node in nodes {
            var subGraph = graph
            subGraph.removeValue(forKey: node)
            for (key, neighbors) in subGraph {
                subGraph[key] = neighbors.filter { $0 != node }
            }
            if !isConnected(graph: subGraph) {
                return false
            }
        }
        return true
    }
    
    /**
     * Checks if a graph is Hamiltonian.
     *
     * - Parameter graph: The graph as a dictionary.
     * - Returns: A boolean indicating if the graph is Hamiltonian.
     */
    func isHamiltonian(graph: [String: [String]]) -> Bool {
        return graph.keys.count <= graph.values.flatMap { $0 }.count / 2
    }
    
    /**
     * Counts the number of degree three vertices in a graph.
     *
     * - Parameter graph: The graph as a dictionary.
     * - Returns: An integer representing the number of degree three vertices.
     */
    func countDegreeThreeVertices(graph: [String: [String]]) -> Int {
        var triangleCount = 0
        for (_, neighbors) in graph {
            for i in 0..<neighbors.count {
                for j in i + 1..<neighbors.count {
                    if graph[neighbors[i]]?.contains(neighbors[j]) == true {
                        triangleCount += 1
                    }
                }
            }
        }
        return triangleCount / 3
    }
    
    /**
     * Checks the neighbors of the maximum degree vertex in two graphs.
     *
     * - Parameters:
     *   - graph1: The first graph as a dictionary.
     *   - graph2: The second graph as a dictionary.
     * - Returns: A boolean indicating if the neighbors of the maximum degree vertex match.
     */
    func maxDegreeVertexNeighborsCheck(graph1: [String: [String]], graph2: [String: [String]]) -> Bool {
        let maxDegree1 = graph1.values.map { $0.count }.max() ?? 0
        let maxDegree2 = graph2.values.map { $0.count }.max() ?? 0
        
        guard let v1 = graph1.first(where: { $0.value.count == maxDegree1 })?.key,
              let v2 = graph2.first(where: { $0.value.count == maxDegree2 })?.key else {
            return false
        }
        
        let neighbors1 = graph1[v1]?.map { graph1[$0]?.count ?? 0 }.sorted() ?? []
        let neighbors2 = graph2[v2]?.map { graph2[$0]?.count ?? 0 }.sorted() ?? []
        
        return neighbors1 == neighbors2
    }
    
    /**
     * Defines a random isomorphism and verifies the edges.
     *
     * - Parameters:
     *   - g1: The first graph as a dictionary.
     *   - g2: The second graph as a dictionary.
     * - Returns: A string describing the isomorphism and the edge mappings, or nil if the graphs are not isomorphic.
     */
    func definisciIsomorfismoCasualeEVerificaArchi(g1: [Int: [Int]], g2: [Int: [Int]]) -> String? {
        let verticesG1 = Array(g1.keys)
        let verticesG2 = Array(g2.keys)
        
        guard verticesG1.count == verticesG2.count else { return nil }
        
        var random = SystemRandomNumberGenerator()
        var mapping: [Int: Int] = [:]
        
        while true {
            let shuffledVerticesG2 = verticesG2.shuffled(using: &random)
            mapping = Dictionary(uniqueKeysWithValues: zip(verticesG1, shuffledVerticesG2))
            
            var edgeMapping = ""
            if verificaArchiMappatiEStampa(g1: g1, g2: g2, mapping: mapping, edgeMapping: &edgeMapping) {
                let result = "\nCalcolo mappatura archi/bigez:\n\(mapping)\n\(edgeMapping)\nTutti gli archi del grafo mappati sono presenti nell'altro.\n"
                return result
            }
        }
    }
    
    /**
     * Verifies the mapped edges and prints the results.
     *
     * - Parameters:
     *   - g1: The first graph as a dictionary.
     *   - g2: The second graph as a dictionary.
     *   - mapping: The mapping of vertices between the two graphs.
     *   - edgeMapping: A string to store the edge mappings.
     * - Returns: A boolean indicating if all mapped edges are present in the other graph.
     */
    func verificaArchiMappatiEStampa(g1: [Int: [Int]], g2: [Int: [Int]], mapping: [Int: Int], edgeMapping: inout String) -> Bool {
        for (source, targets) in g1 {
            for target in targets {
                let mappedSource = mapping[source]!
                let mappedTarget = mapping[target]!
                
                if !(g2[mappedSource]?.contains(mappedTarget) ?? false) {
                    return false
                } else {
                    edgeMapping += "\(source)-\(target) -> \(mappedSource)-\(mappedTarget)\n"
                }
            }
        }
        return true
    }
}

/**
 * Modal view to display the result string.
 */
struct ModalView: View {
    @Binding var resultString: String
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                Text(resultString)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                showModal = false
            }) {
                Text("Indietro")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

/**
 * Preview provider for the Isomorphisms view.
 */
#Preview {
    Isomorphisms(isoData: IsoData())
}

/**
 * IsoData model to hold the state of the graphs.
 */
class IsoData: ObservableObject {
    @Published var graph1: String = ""
    @Published var graph2: String = ""
    @Published var graph3: String = ""
}
