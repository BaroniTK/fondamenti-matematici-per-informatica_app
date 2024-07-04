//
//  ModTool.swift
//  Fondamenti
//
//  Created by Michele Calliari on 11/05/24.
//
import SwiftUI
import Foundation

/**
 * View for the ModTool, which calculates the modulo of a given number.
 */
struct ModTool: View {
    @State private var result = ""
    @ObservedObject var toolData: ToolData
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Modulo:")
                    .font(.headline)
                
                TextField("Numero", text: $toolData.number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Mod", text: $toolData.mod)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Spacer()
                    Text(result)
                        .padding(.top, 8) // Space between TextFields and the result
                    Spacer()
                }
            }
            
            Spacer() // Spacer to push the button down
            
            HStack {
                Spacer()
                Button(action: {
                    // Calculate the modulo and update the result
                    let num = evaluateExpression(expression: toolData.number)
                    let modValue = Int(toolData.mod) ?? 1
                    let modulo = num % modValue
                    let quoziente = num / modValue
                    result = "\(toolData.number) mod \(toolData.mod) = \(modValue)*\(quoziente) + \(modulo)"
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
        .navigationTitle("CalcolaModulo")
    }
    
    /**
     * Evaluates a mathematical expression.
     *
     * - Parameter expression: The string containing the mathematical expression to evaluate.
     * - Returns: The integer result of the evaluated expression.
     */
    private func evaluateExpression(expression: String) -> Int {
        var cleanedExpression = expression.replacingOccurrences(of: "^", with: "**") // Update the power operator
        cleanedExpression = cleanedExpression.replacingOccurrences(of: " ", with: "") // Remove spaces
        
        // Use NSExpression to evaluate the expression
        let expressionToEvaluate = NSExpression(format: cleanedExpression)
        guard let evaluatedValue = expressionToEvaluate.expressionValue(with: nil, context: nil) as? Int else {
            return 0
        }
        return evaluatedValue
    }
}

/**
 * Preview provider for the ModTool view.
 */
struct ModToolView_Previews: PreviewProvider {
    static var previews: some View {
        ModTool(toolData: ToolData())
    }
}

/**
 * ToolData model to hold the state of the tool.
 */
class ToolData: ObservableObject {
    @Published var number = ""
    @Published var mod = ""
}
