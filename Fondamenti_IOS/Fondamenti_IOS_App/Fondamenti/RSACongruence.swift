//
//  RSACongruence.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import SwiftUI
import Foundation

/**
 * Decomposes a number into its prime factors.
 *
 * - Parameter n: The number to decompose.
 * - Returns: An array of prime factors of the number.
 */
func fattoriPrimi(_ n: Int) -> [Int] {
    var n = n
    var i = 2
    var factors = [Int]()
    while i * i <= n {
        if n % i != 0 {
            i += 1
        } else {
            n /= i
            factors.append(i)
        }
    }
    if n > 1 {
        factors.append(n)
    }
    return factors
}

/**
 * Calculates the Euler's totient function (phi) of a number.
 *
 * - Parameter n: The number to calculate phi for.
 * - Returns: The value of phi(n).
 */
func phiEulero(_ n: Int) -> Int {
    var n = n
    var result = n
    var p = 2
    while p * p <= n {
        if n % p == 0 {
            while n % p == 0 {
                n /= p
            }
            result -= result / p
        }
        p += 1
    }
    if n > 1 {
        result -= result / n
    }
    return result
}

/**
 * Performs the Euclidean algorithm with backward substitution on two numbers.
 *
 * - Parameters:
 *   - a: The first integer.
 *   - b: The second integer.
 * - Returns: A tuple containing the multiplier for the power and a string with all steps.
 */
func euclideanAlgorithm2(_ a: Int, _ b: Int) -> (Int, String) {
    var a = a
    var b = b
    let keep = b
    var x0 = 1, x1 = 0, y0 = 0, y1 = 1
    let a0 = a, b0 = b
    var str = ""
    
    // Initial step if b is less than or equal to a
    if b <= a {
        str += "\(a) = \(a / b)*\(b) + \(a % b)\n"
    }
    
    while b != 0 {
        let q = a / b
        (a, b) = (b, a % b)
        (x0, x1) = (x1, x0 - q * x1)
        (y0, y1) = (y1, y0 - q * y1)
        
        if b != 0 {
            str += "\(a) = \(a / b)*\(b) + \(a % b)\n"
        }
    }
    str += "MCD = \(a) = \(x0)*\(a0) + \(y0)*\(b0)\n"
    var z = 0
    if a0 != keep {
        z = x0
    } else {
        z = y0
    }
    
    while z < 0 {
        z += keep
    }
    
    return (z, str)
}

/**
 * Calculates the modular exponentiation.
 *
 * - Parameters:
 *   - k: The exponent.
 *   - residue: The base.
 *   - modulus: The modulus.
 * - Returns: A string showing the step-by-step calculation of the modular exponentiation.
 */
func calculateModularExponentiation(_ k: Int, residue: Int, modulus: Int) -> String {
    var result = 1
    var str = ""
    for i in 1...k {
        result = (result * residue) % modulus
        str += "\(residue)^\(i) (mod \(modulus)) = \(result)\n"
    }
    return str
}

/**
 * Calculates the minimum positive and maximum negative solutions of a congruence.
 *
 * - Parameters:
 *   - k: The exponent.
 *   - residue: The base.
 *   - modulus: The modulus.
 * - Returns: A string showing the minimum positive and maximum negative solutions.
 */
func congruenceSolver(_ k: Int, residue: Int, modulus: Int) -> String {
    var solutions = [Int]()
    for x in 0..<modulus {
        var result = 1
        for _ in 0..<k {
            result = (result * x) % modulus
        }
        if result == residue {
            solutions.append(x)
        }
    }
    if solutions.isEmpty {
        return "Non ci sono soluzioni.\n"
    }
    let minPositiveSolution = solutions.min()!
    let maxNegativeSolution = solutions.map { $0 - modulus }.max()!
    return "Minima soluzione positiva: \(minPositiveSolution)\nMassima soluzione negativa: \(maxNegativeSolution)\n"
}

/**
 * Executes the entire RSA congruence process.
 *
 * - Parameters:
 *   - potenza: The exponent.
 *   - number: The base.
 *   - mod: The modulus.
 * - Returns: A string showing the detailed steps and results of the process.
 */
func menu2(potenza: Int, number: Int, mod: Int) -> String {
    var result = ""
    
    result += "Scomposizione in fattori primi (1):\n"
    result += "\(number) = \(fattoriPrimi(number))\n"
    result += "\(mod) = \(fattoriPrimi(mod))\n\n"
    
    let phi = phiEulero(mod)
    result += "Scomposizione in fattori primi (2):\n"
    result += "\(potenza) = \(fattoriPrimi(potenza))\n"
    result += "phi(\(mod)) = \(phi) = \(fattoriPrimi(phi))\n\n"
    
    let (f, ff) = euclideanAlgorithm2(potenza, phi)
    
    result += "MCD con sostituz a ritroso su \(potenza) e phi(\(mod)):\n"
    result += "\(ff)\n"
    
    result += "d:=\(f)\n"
    result += "Calcolo orbita \(number)^\(f)mod\(mod):\n"
    result += "\(calculateModularExponentiation(f, residue: number, modulus: mod))"
    
    result += "\nTrovo soluz max e min:\n"
    result += "\(congruenceSolver(potenza, residue: number, modulus: mod))\n"
    
    return result
}

/**
 * Modal view to display the content of the text fields.
 */
struct ModalView2: View {
    @Environment(\.presentationMode) var presentationMode
    
    var potenza: Int
    var mod: Int
    var number: Int
    
    var body: some View {
        ScrollView {
            VStack {
                Text(menu2(potenza: potenza, number: number, mod: mod))
                    .padding()
                
                Spacer()
                
                Button("Indietro") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .navigationBarTitle("Risultati")
    }
}

/**
 * Main view for the RSA Congruence section.
 */
struct RSACongruence: View {
    @ObservedObject var rsaData: RSAData
    @State private var showModal = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Congruenza:")
                    .font(.headline)
                
                TextField("Potenza", text: $rsaData.potenza)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Numero", text: $rsaData.number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Mod", text: $rsaData.mod)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer() // Spacer to push the button down
            
            HStack {
                Spacer()
                Button(action: {
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
        .navigationTitle("RSA")
        .sheet(isPresented: $showModal) {
            // Pass the values from the text fields to the modal view
            ModalView2(potenza: Int(rsaData.potenza) ?? 0, mod: Int(rsaData.mod) ?? 0, number: Int(rsaData.number) ?? 0)
        }
    }
}

/**
 * Preview provider for "RSACongruence".
 */
struct RSACongruenceView_Previews: PreviewProvider {
    static var previews: some View {
        RSACongruence(rsaData: RSAData())
    }
}

class RSAData: ObservableObject {
    @Published var potenza = ""
    @Published var number = ""
    @Published var mod = ""
}
