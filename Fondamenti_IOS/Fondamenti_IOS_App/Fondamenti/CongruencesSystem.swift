//
//  CongruenceSystem.swift
//  Fondamenti
//
//  Created by Michele Calliari on 31/05/24.
//
import SwiftUI
import Foundation

/**
 * Calcola l'MCD utilizzando l'algoritmo di Euclide con sostituzione inversa.
 *
 * - Parameters:
 *   - a: Il primo intero.
 *   - b: Il secondo intero.
 * - Returns: Una stringa che descrive i passaggi per calcolare l'MCD.
 */
func algoritmoEuclideo(_ a: Int, _ b: Int) -> String {
    var (x0, x1, y0, y1) = (1, 0, 0, 1)
    let (a0, b0) = (a, b)
    var (a, b) = (a, b)
    var result = ""
    while b != 0 {
        result += "\(a) = \(a / b) * \(b) + \(a % b)\n"
        let q = a / b
        (a, b) = (b, a % b)
        (x0, x1) = (x1, x0 - q * x1)
        (y0, y1) = (y1, y0 - q * y1)
    }
    result += "MCD = \(a) = \(x0) * \(a0) + \(y0) * \(b0)"
    return result
}

/**
 * Risolve il sistema di congruenze dato.
 *
 * - Parameters:
 *   - a: Il primo numero.
 *   - k: Il modulo per la prima congruenza.
 *   - b: Il secondo numero.
 *   - j: Il modulo per la seconda congruenza.
 * - Returns: Una stringa che descrive la soluzione al sistema di congruenze.
 */
func risolviCongruenze(_ a: Int, _ k: Int, _ b: Int, _ j: Int) -> String {
    let s = abs(a - b)
    
    var (mcd, k0, j0) = euclide(k, j)
    
    let div = Double(s) / Double(mcd)
    
    k0 = Int(Double(k0) * Double(k) * div)
    j0 = Int(Double(j0) * Double(j) * div)
    
    var a1 = 0, b1 = 0, var1 = 0, var2 = 0
    if(a > b){
        a1 = a
        b1 = -1*b
        var1 = a1 - k0
        var2 = -1*b1 + j0
    }else{
        a1 = -1*a
        b1 = b
        var1 = -1*a1 + k0
        var2 = b1 - j0
    }
    
    print(a1, b1)
    print(var1, var2)
    
    var c = 0
    
    if(var1 == var2) {
        c = Int(var1)
    }
    
    var result = "C = \(c)\n"
    let m = mcm(k, j)
    
    while c < 0 {
        c += m
    }
    
    let MCM = mcm(k, j)
    
    while (c > 0){
        c -= MCM
    }
    
    c += MCM
    result += "S = [\(c)]\(MCM)"
    
    return result
}

/**
 * Restituisce l'MCD e i due coefficienti per la combinazione lineare.
 *
 * - Parameters:
 *   - a: Il primo intero.
 *   - b: Il secondo intero.
 * - Returns: Una tupla contenente l'MCD e i coefficienti.
 */
func euclide(_ a: Int, _ b: Int) -> (Int, Int, Int) {
    var (x0, x1, y0, y1) = (1, 0, 0, 1)
    let (_, _) = (a, b)
    var (a, b) = (a, b)
    while b != 0 {
        let q = a / b
        (a, b) = (b, a % b)
        (x0, x1) = (x1, x0 - q * x1)
        (y0, y1) = (y1, y0 - q * y1)
    }
    return (a, x0, y0)
}

/**
 * Calcola l'MCD normalmente.
 *
 * - Parameters:
 *   - a: Il primo intero.
 *   - b: Il secondo intero.
 * - Returns: L'MCD dei due interi.
 */
func mcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return a
}

/**
 * Calcola il mcm.
 *
 * - Parameters:
 *   - a: Il primo intero.
 *   - b: Il secondo intero.
 * - Returns: Il mcm dei due interi.
 */
func mcm(_ a: Int, _ b: Int) -> Int {
    return (a * b) / mcd(a, b)
}

/**
 * Esegue l'esercizio.
 *
 * - Parameters:
 *   - xNumber: Il primo numero.
 *   - xMod: Il modulo per il primo numero.
 *   - yNumber: Il secondo numero.
 *   - yMod: Il modulo per il secondo numero.
 * - Returns: Una vista di testo con il risultato dei calcoli.
 */
func menu(xNumber: Int, xMod: Int, yNumber: Int, yMod: Int) -> Text {
    let k = xMod
    let j = yMod
    
    var result = ""
    
    if k > j {
        result += "\nCALCOLO MCD CON EUCLIDE E SOSTITUZIONE INVERSA:\n"
        result += "\(algoritmoEuclideo(k, j))\n"
        result += "MCM = \(mcm(k, j))\n"
    } else {
        result += "\nCALCOLO MCD CON EUCLIDE E SOSTITUZIONE INVERSA:\n"
        result += "\(algoritmoEuclideo(j, k))\n"
        result += "MCM = \(mcm(j, k))\n"
    }
    result += "\nRISULTATI FINALI:\n"
    result += "\(risolviCongruenze(xNumber, k, yNumber, j))"
    
    return Text(result)
}

/**
 * Vista modale per visualizzare il contenuto dei campi di testo.
 */
struct ModalView6: View {
    @Environment(\.presentationMode) var presentationMode
    
    var xNumber: Int
    var xMod: Int
    var yNumber: Int
    var yMod: Int
    
    var body: some View {
        VStack {
            menu(xNumber: xNumber, xMod: xMod, yNumber: yNumber, yMod: yMod)
            
            Spacer()
            
            Button(action: {
                // Chiude la vista modale
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Indietro")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

/**
 * Vista principale per la sezione "CongruencesSystem".
 */
struct CongruencesSystem: View {
    @ObservedObject var congruenceData: CongruenceData
    @State private var showModal = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Prima congruenza:")
                    .font(.headline)
                
                TextField("Numero", text: $congruenceData.xNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Mod", text: $congruenceData.xMod)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Group {
                Text("Seconda congruenza:")
                    .font(.headline)
                
                TextField("Numero", text: $congruenceData.yNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Mod", text: $congruenceData.yMod)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer() // Spacer per spingere il pulsante verso il basso
            
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
        .navigationTitle("Sistema")
        .sheet(isPresented: $showModal) {
            // Passa i valori dai campi di testo alla vista modale
            ModalView6(xNumber: Int(congruenceData.xNumber) ?? 0, xMod: Int(congruenceData.xMod) ?? 0, yNumber: Int(congruenceData.yNumber) ?? 0, yMod: Int(congruenceData.yMod) ?? 0)
        }
    }
}

/**
 * Preview provider per "CongruencesSystem".
 */
struct CongruencesSystemView_Previews: PreviewProvider {
    static var previews: some View {
        CongruencesSystem(congruenceData: CongruenceData())
    }
}

/**
 * Modello CongruenceData per mantenere lo stato del sistema.
 */
class CongruenceData: ObservableObject {
    @Published var xNumber = ""
    @Published var xMod = ""
    @Published var yNumber = ""
    @Published var yMod = ""
}
