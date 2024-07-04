//
//  Score.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import SwiftUI

/**
 * View for calculating and analyzing graph scores.
 */
struct Score: View {
    @ObservedObject var scoreData: ScoreData
    @State private var showModal: Bool = false
    @State private var calculationResult: String = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Group {
                    Text("Primo score:")
                        .font(.headline)
                    
                    TextField("d1: x1,x2,...xn", text: $scoreData.textField1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Group {
                    Text("Secondo score:")
                        .font(.headline)
                    
                    TextField("d2: x1,x2,...xn", text: $scoreData.textField2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Toggle(isOn: $scoreData.isHamiltonian) {
                    Text("Hamiltoniano")
                }
                .padding(.bottom, 10)
                
                Toggle(isOn: $scoreData.isDisconnected) {
                    Text("Sconnesso")
                }
                .padding(.bottom, 10)
                
                Toggle(isOn: $scoreData.isDueConnesso) {
                    Text("2-Connesso")
                }
                .padding(.bottom, 10)
                
                Toggle(isOn: $scoreData.isAlbero) {
                    Text("Albero")
                }
                .padding(.bottom, 10)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        calculate()
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
            .navigationTitle("Score grafi")
            .sheet(isPresented: $showModal) {
                ModalView4(showModal: $showModal, result: $calculationResult)
            }
            .onAppear {
                // Observe keyboard notifications
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height - geometry.safeAreaInsets.bottom
                    }
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.keyboardHeight = 0
                }
            }
            .padding(.bottom, keyboardHeight)
        }
    }
    
    /**
     * Verifies obstructions in a degree sequence.
     *
     * - Parameters:
     *   - vettore: The degree sequence as an array of integers.
     *   - nomeVettore: The name of the degree sequence.
     * - Returns: A string indicating whether the sequence passes the obstruction checks.
     */
    func verificaOstruzioni(vettore: [Int], nomeVettore: String) -> String {
        let n = vettore.count
        let maxVal = vettore.max()!
        let minVal = vettore.min()!
        
        if maxVal > n - 1 {
            return "\(nomeVettore) NO a causa dell'ostruzione 1"
        }
        
        if maxVal == n - 1 {
            if minVal < vettore.filter({ $0 == maxVal }).count {
                return "\(nomeVettore) NO a causa dell'ostruzione 2"
            }
        }
        
        if n > 2 {
            let L = vettore.dropLast(2).filter { $0 >= 2 }.count
            let K = vettore.suffix(2).reduce(0, +) - n
            if L < K {
                return "\(nomeVettore) NO a causa dell'ostruzione 3"
            }
        }
        
        let numDispari = vettore.filter { $0 % 2 != 0 }.count
        if numDispari % 2 != 0 {
            return "\(nomeVettore) NO a causa dell'ostruzione 4"
        }
        
        return "\(nomeVettore) SI"
    }
    
    /**
     * Applies the degree sequence theorem to a vector.
     *
     * - Parameter vettore: The degree sequence as an array of integers.
     * - Returns: A string showing the steps of applying the theorem.
     */
    func teoremaDelloScore(vettore: inout [Int]) -> String {
        var result = "TEOREMA DELLO SCORE\n"
        result += "\(vettore)\n"
        while vettore.max()! > 2 {
            let n = vettore.removeLast()
            for i in 1...n {
                vettore[vettore.count - i] -= 1
            }
            
            result += "\(vettore)\n"
            vettore.sort()
            result += "vettore ordinato: \n\(vettore)\n"
        }
        return result
    }
    
    /**
     * Checks if a graph is disconnected.
     *
     * - Parameter graph: The adjacency list of the graph.
     * - Returns: A boolean indicating if the graph is disconnected.
     */
    func isDisconnected(graph: [[Int]]) -> Bool {
        return !isConnected(graph: graph)
    }
    
    /**
     * Checks if a graph is connected.
     *
     * - Parameter graph: The adjacency list of the graph.
     * - Returns: A boolean indicating if the graph is connected.
     */
    func isConnected(graph: [[Int]]) -> Bool {
        var visited = [Bool](repeating: false, count: graph.count)
        var queue = [0]
        visited[0] = true
        while !queue.isEmpty {
            let node = queue.removeFirst()
            for neighbor in graph[node] {
                if !visited[neighbor] {
                    visited[neighbor] = true
                    queue.append(neighbor)
                }
            }
        }
        return visited.allSatisfy { $0 }
    }
    
    /**
     * Converts a comma-separated string to an array of integers.
     *
     * - Parameter input: The input string.
     * - Returns: An array of integers, or nil if conversion fails.
     */
    func stringToIntArray(_ input: String) -> [Int]? {
        let components = input.split(separator: ",")
        let intArray = components.compactMap { Int($0) }
        
        // Verifies if all components were successfully converted
        if intArray.count == components.count {
            return intArray
        } else {
            return nil
        }
    }
    
    /**
     * Finds and describes a graph given its degree sequence and properties.
     *
     * - Parameters:
     *   - vettore: The degree sequence.
     *   - hamiltoniano: Whether the graph should be Hamiltonian.
     *   - sconnesso: Whether the graph should be disconnected.
     *   - dueConnesso: Whether the graph should be 2-connected.
     *   - albero: Whether the graph should be a tree.
     * - Returns: A string describing the graph and its properties.
     */
    func trovaGrafo(vettore: [Int], hamiltoniano: Bool, sconnesso: Bool, dueConnesso: Bool, albero: Bool) -> String {
        let n = vettore.count
        var graph = [[Int]](repeating: [Int](), count: n)
        
        for i in 0..<n {
            for j in i + 1..<n {
                if vettore[i] + vettore[j] >= n {
                    graph[i].append(j)
                    graph[j].append(i)
                }
            }
        }
        
        var result = ""
        
        let disconnectionForced = forceDisconnection(vettore: vettore)
        let connectionForced = forceConnection(vettore: vettore)
        
        if connectionForced{
            result += "Forzatura alla connessione verificata\n"
        }else{
            result += "Forzatura alla connessione NON verificata\n"
        }
        
        if disconnectionForced{
            result += "Forzatura alla sconnessione verificata\n"
        }else{
            result += "Forzatura alla sconnessione NON verificata\n"
        }
        
        if sconnesso {
            if connectionForced {
                result += "Sconnesso NO\n"
            } else {
                result += "Sconnesso " + (isDisconnected(graph: graph) ? "SI" : "NO") + "\n"
            }
        }
        
        if hamiltoniano {
            if disconnectionForced {
                result += "Hamiltoniano NO\n"
            } else {
                result += "Hamiltoniano " + (contains_hamiltonian_cycle(degree_sequence: vettore) ? "SI" : "NO") + "\n"
            }
        }
        
        if dueConnesso {
            if disconnectionForced {
                result += "2-Connesso NO\n"
            } else {
                result += "2-Connesso " + (is_2_connected(degree_sequence: vettore) ? "SI" : "NO") + "\n"
            }
        }
        
        if albero {
            if disconnectionForced {
                result += "Albero NO\n"
            } else {
                result += "Albero " + (is_tree(degree_sequence: vettore) ? "SI" : "NO") + "\n"
            }
        }
        
        return result
    }
    
    /**
     * Forces a degree sequence to be disconnected.
     *
     * - Parameter vettore: The degree sequence.
     * - Returns: A boolean indicating if the sequence can be forced to be disconnected.
     */
    func forceDisconnection(vettore: [Int]) -> Bool {
        let sum = vettore.reduce(0, +)
        let n = vettore.count
        return (1.0 / 2.0) * Double(sum) < Double(n - 1)
    }
    
    /**
     * Forces a degree sequence to be connected.
     *
     * - Parameter vettore: The degree sequence.
     * - Returns: A boolean indicating if the sequence can be forced to be connected.
     */
    func forceConnection(vettore: [Int]) -> Bool {
        let n = vettore.count
        let firstElement = vettore.first!
        let lastElement = vettore.last!
        return firstElement >= n - lastElement - 1
    }
    
    /**
     * Main function for calculating graph properties based on degree sequences.
     *
     * - Parameters:
     *   - d1: The first degree sequence as a string.
     *   - d2: The second degree sequence as a string.
     *   - hamiltoniano: Whether to check for Hamiltonian property.
     *   - sconnesso: Whether to check for disconnected property.
     *   - dueConnesso: Whether to check for 2-connected property.
     *   - albero: Whether to check for tree property.
     * - Returns: A string summarizing the calculation results.
     */
    func main(d1: String, d2: String, hamiltoniano: Bool, sconnesso: Bool, dueConnesso: Bool, albero: Bool) -> String {
        let vettore1 = d1.split(separator: ",").compactMap { Int($0) }
        let vettore2 = d2.split(separator: ",").compactMap { Int($0) }
        
        var output = ""
        
        let result1 = verificaOstruzioni(vettore: vettore1, nomeVettore: "d1")
        let result2 = verificaOstruzioni(vettore: vettore2, nomeVettore: "d2")
        
        output += result1 + "\n" + result2 + "\n"
        
        var vettoreSopravvissuto: [Int]
        if !result1.contains("NO") {
            vettoreSopravvissuto = vettore1
        } else if !result2.contains("NO") {
            vettoreSopravvissuto = vettore2
        } else {
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var vettoreSopravvissutoCopy = vettoreSopravvissuto
        output += teoremaDelloScore(vettore: &vettoreSopravvissutoCopy)
        output += trovaGrafo(vettore: vettoreSopravvissuto, hamiltoniano: hamiltoniano, sconnesso: sconnesso, dueConnesso: dueConnesso, albero: albero)
        
        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**
     * Calculates the results and shows the modal view.
     */
    private func calculate() {
        calculationResult = main(d1: scoreData.textField1, d2: scoreData.textField2, hamiltoniano: scoreData.isHamiltonian, sconnesso: scoreData.isDisconnected, dueConnesso: scoreData.isDueConnesso, albero: scoreData.isAlbero)
        showModal = true
    }
}

/**
 * Modal view to display the calculation result.
 */
struct ModalView4: View {
    @Binding var showModal: Bool
    @Binding var result: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(result)
                .padding(.leading)
                .padding(.top)
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            
            Spacer()
            
            HStack {
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
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

/**
 * Preview provider for the Score view.
 */
#Preview {
    Score(scoreData: ScoreData())
}

/**
 * scoreData model to hold the state of the graphs.
 */
class ScoreData: ObservableObject {
    @Published var textField1 = ""
    @Published var textField2 = ""
    @Published var isHamiltonian = false
    @Published var isDisconnected = false
    @Published var isDueConnesso = false
    @Published var isAlbero = false
    @Published var showModal = false
    @Published var calculationResult = ""
}
