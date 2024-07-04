//
//  Theorems.swift
//  Fondamenti
//
//  Created by Michele Calliari on 03/06/24.
//

import SwiftUI
import WebKit

struct Theorems: View {
    let elements = ["Buon ordinamento e seconda forma induzione",
                    "Esistenza e unicità divisione euclidea",
                    "Unicità numero base arbitraria", "Esistenza e unicità MCM, mcd",
                    "Teorema fondamentale dell'aritmetica", "Teorema cinese del resto",
                    "Teorema di Fermat-Eulero e RSA", "Teoremi congiungibilità grafi",
                    "Relazione grafi finiti e lemma strette di mano",
                    "Teorema caratterizzazione alberi finiti",
                    "Teorema esistenza alberi copertura"]
    
    var body: some View {
        NavigationView {
            List(elements.indices, id: \.self) { index in
                NavigationLink(destination: DetailView(detailText: self.getDetailText(for: index))) {
                    Text(elements[index])
                        .padding()
                        .cornerRadius(8)
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Teoremi")
    }
    
    func getDetailText(for index: Int) -> String {
        switch index {
        case 0: return self.detailText1()
        case 1: return self.detailText2()
        case 2: return self.detailText3()
        case 3: return self.detailText4()
        case 4: return self.detailText5()
        case 5: return self.detailText6()
        case 6: return self.detailText7()
        case 7: return self.detailText8()
        case 8: return self.detailText9()
        case 9: return self.detailText10()
        case 10: return self.detailText11()
        default: return "Unknown Element"
        }
    }
    
    func detailText1() -> String {
        return """
        \\( \\textbf{Teorema 1} \\text{ (Buon ordinamento dei numeri naturali). } (\\mathbb{N}, \\leq) \\text{ è ben ordinato.} \\)
        
        \\( \\text{Dimostrazione. Supponiamo esista } A \\subset \\mathbb{N} \\text{ tale che non esiste un } \\min A. \\)
        \\( \\text{Sia } B := \\mathbb{N} \\setminus A. \\text{ Dimostriamo che } B = \\mathbb{N} \\text{ e } A = \\emptyset. \\)
        \\( \\text{Procediamo per induzione di prima forma. Sia } \\{0, 1, \\ldots, n\\} \\subset B \\ \\forall n \\in \\mathbb{N}, \\)
        \\( \\text{ovvero } P(n) = (\\{0, 1, \\ldots, n\\} \\subset B) \\text{ è vera } \\forall n \\in \\mathbb{N}. \\)
        
        \\( \\textbf{Base dell'induzione} \\)
        \\( \\textbf{n = 0} \\)
        \\( \\{0\\} \\subset B \\iff 0 \\in B \\iff 0 \\notin A. \\)
        \\( \\text{Se supponessimo per assurdo che } 0 \\in A, \\text{ allora avremmo che } 0 = \\min A. \\text{ Quindi } 0 \\notin A. \\)
        
        \\( \\textbf{Passo induttivo} \\)
        \\(\\boldsymbol{n \\geq 1, n \\implies n + 1}\\)
        \\( \\text{ Assumiamo che } \\{0, 1, \\ldots, n\\} \\subset B \\text{ per qualche } n. \\)
        \\( \\text{Proviamo che } \\{0, 1, \\ldots, n, n + 1\\} \\subset B. \\)
        \\( n + 1 \\in A? \\text{ No, perché altrimenti avremmo che } n + 1 = \\min A. \\)
        \\( \\text{Allora} \\)
        \\( n + 1 \\in B \\implies B = \\mathbb{N}, A = \\emptyset. \\)
        
        \\( \\textbf{Teorema 2} \\text{ (Seconda forma del principio di induzione). Sia una famiglia di proposizioni } \\{P(n)\\}_{n \\in \\mathbb{N}} \\text{ indicizzata su } n \\in \\mathbb{N}. \\text{ Supponiamo che} \\)
        
        \\( 1. \\ P(0) \\text{ è vera} \\)
        
        \\( 2. \\ \\forall n > 0, \\ P(k) \\text{ è vera } \\forall k < n \\implies P(n) \\text{ è vera}. \\)
        
        \\( \\text{Allora } P(n) \\text{ è vera } \\forall n \\in \\mathbb{N}. \\)
        
        \\( \\text{Dimostrazione. Sia } A := \\{n \\in \\mathbb{N} \\mid P(n) \\text{ è falsa}\\}, \\text{ dimostriamo che } A = \\emptyset. \\)
        \\( \\text{Supponiamo che} \\)
        \\( A \\neq \\emptyset \\implies \\exists n \\in \\mathbb{N} : n = \\min A. \\text{ Per la (1), essendo } P(0) \\text{ vera}, n \\neq 0. \\)
        \\( \\text{Inoltre, se } k < n, k \\notin A \\text{ in quanto abbiamo che } n = \\min A, \\text{ ma allora dalla (2) segue che} \\)
        \\( P(n) \\text{ è vera e che quindi } n \\notin A, \\text{ che è in contraddizione con quanto asserito all'inizio della dimostrazione.} \\)
        """
    }
    
    func detailText2() -> String {
        return """
        \\( \\textbf{Teorema 3} \\text{ (Esistenza e unicità della divisione euclidea). Siano } n, m \\in \\mathbb{Z} \\text{ con } m \\neq 0. \\implies \\exists! q, r \\in \\mathbb{Z} : \\)
        
        \\( \\bullet \\ n = qm + r \\)
        \\( \\bullet \\ 0 \\leq r < |m| \\)
        
        \\( \\text{Esistenza. Procediamo per induzione di seconda forma su } n. \\)
        
        \\( \\textbf{ passo base: n = 0 } \\)
        \\( \\text{ Poniamo } q, r = 0. \\)
        
        \\( \\textbf{Passo induttivo} \\)
        \\( \\boldsymbol{ n \\geq 1, \\forall k < n \\implies n }\\)
        \\( \\text{Supponiamo } n > 0 \\text{ e l'asserto vero } \\forall k < n. \\text{ Dimostriamo che l'asserto vale } \\forall n \\in \\mathbb{N}. \\)
        
        \\( \\bullet \\ \\text{Consideriamo innanzitutto il caso } n \\geq 0. \\text{ Se } n < m, \\text{ poniamo } q := 0 \\text{ e } r := n. \\)
        \\( \\bullet \\ \\text{Altrimenti, avremo che } n \\geq m. \\text{ Sia } k := n - m. \\)
        \\( \\text{Applicando la divisione euclidea, otteniamo che:} \\)
        \\( \\exists q, r \\in \\mathbb{N} : k = mq + r, \\ 0 \\leq k < n, \\)
        \\( \\iff n = k + m = (qm + r) + m = (q + 1)m + r. \\)
        
        \\( \\text{Analizziamo ora il caso opposto, ovvero quando } n < 0. \\text{ Se } m > 0, \\text{ applicando la procedura di divisione euclidea a } -n > 0, m > 0, \\text{ vale:} \\)
        \\( \\implies \\exists q, r \\in \\mathbb{N} : -n = qm + r, \\ 0 \\leq r < |m| \\)
        \\( \\iff n = -(qm + r) \\)
        \\( \\text{Se } r = 0 \\text{ abbiamo } \\text{ finito, altrimenti continuiamo per ottenere un resto } > 0. \\text{ Aggiungendo e togliendo } m: \\)
        \\( n = (-q) - r - m + m \\)
        \\( = (-q - 1)m + (m - r) \\)
        \\( \\text{dove } m - r \\text{ è strettamente positivo per definizione.} \\)
        \\( \\text{Sia infine } m < 0, \\text{ ovvero } -m > 0. \\)
        
        \\( \\exists q, r \\in \\mathbb{Z} : n = (-m)q + r, \\ 0 \\leq r < |m| \\)
        \\( \\iff n = (-q)m + r \\)
        
        \\( \\text{Unicità. Supponiamo } \\exists n, m \\in \\mathbb{Z}, m \\neq 0; q, q', r, r' \\in \\mathbb{N}: \\)
        \\( n = qm + r, \\ 0 \\leq r < |m| \\)
        \\( n = q'm + r', \\ 0 \\leq r' < |m| \\)
        
        \\( \\text{Proviamo che } q = q', r = r'. \\text{ Possiamo supporre che } r' > r. \\text{ Allora vale:} \\)
        \\( qm - q'm = r' - r \\iff m(q - q') = r' - r. \\text{ Effettuando l'operazione di modulo otteniamo:} \\)
        \\( |m(q - q')| = |r' - r| = r' - r < |m| \\)
        
        \\( \\text{Affinché la disuguaglianza sia rispettata deve essere } 0 \\leq |q - q'| < 1. \\)
        \\( \\text{Essendo } q, q' \\in \\mathbb{N}, \\text{ concludiamo che } q' - q = 0 \\implies q' = q. \\)
        \\( \\text{Dall'equazione originale ricaviamo infine che: } mq + r = mq' + r' \\implies r' = r. \\)
        """
    }
    
    func detailText3() -> String {
        return """
        \\( \\textbf{Teorema 4} \\text{ (Unicità della rappresentazione di un numero in base } b \\geq 2 \\text{ arbitraria). Sia } b \\in \\mathbb{N}, b \\geq 2 \\implies \\forall n \\in \\mathbb{N}, \\exists! \\text{ rappresentazione di } n \\text{ in base } b, \\text{ ovvero una successione } \\{ \\varepsilon_i \\} \\text{ con le seguenti proprietà:} \\)
        
        \\( 1. \\ \\{\\varepsilon_i\\}_{i \\in \\mathbb{N}} \\text{ è definitivamente nulla dopo qualche } i_0 \\in \\mathbb{N}, \\text{ ovvero } \\forall j \\geq i_0, \\varepsilon_j = 0. \\)
        \\( 2. \\ \\varepsilon_i \\in I_b = \\{0, 1, \\ldots, b - 1 \\} \\forall i \\in \\mathbb{N} \\text{ (ovvero } 0 \\leq \\varepsilon_i < b) \\)
        \\( 3. \\ \\sum_{i \\in \\mathbb{N}} \\varepsilon_i b^i = n \\)
        
        \\( \\text{Inoltre, se esiste un'altra successione } \\{ \\varepsilon_i' \\}_{i \\in \\mathbb{N}} \\text{ allora } \\varepsilon_i = \\varepsilon_i' \\forall i \\in \\mathbb{N}. \\)
        
        \\( \\text{Esistenza. Procediamo per induzione di seconda forma su } n. \\)
        
        \\( \\textbf{passo base: n = 0} \\)
        \\( \\text{Vale:} \\)
        \\( n = \\sum_{i \\in \\mathbb{N}} \\varepsilon_i b^i = \\sum_{i \\in \\mathbb{N}} 0b^i = 0b \\)
        \\( \\forall i \\in \\mathbb{N}. \\)
        
        \\( \\textbf{Passo induttivo} \\)
        \\(\\boldsymbol{n \\geq 1, \\forall k < n \\implies n} \\)
        \\( \\text{Supponiamo } n > 0 \\text{ e l'asserto vero } \\forall k < n. \\text{ Eseguiamo la divisione euclidea di } n \\text{ con } b: \\)
        \\( n = qb + r, \\ 0 \\leq r < |b| \\)
        \\( \\text{Per ipotesi sappiamo che } b \\geq 2, \\text{ quindi vale } 0 < q < qb \\leq qb + r = n. \\)
        \\( \\text{Per ipotesi induttiva allora esiste una successione } \\{ \\delta_i \\} \\text{ che possiede le proprietà (1), (2), (3); inoltre vale:} \\)
        \\( n = \\left( \\sum \\delta_i b^i \\right) b + r \\)
        \\( n = \\left( \\sum \\delta_i b^{i+1} \\right) + r \\)
        \\( \\text{Sia ora } r = \\varepsilon_0; \\text{ effettuando un cambio di indice, otteniamo:} \\)
        \\( n = \\varepsilon_0 + \\sum_{j \\geq 1} \\delta_{j-1} b^j = \\varepsilon_0 + \\delta_0 b^1 + \\delta_1 b^2 + \\ldots = \\sum_{i \\in \\mathbb{N}} \\varepsilon_i b^i \\)
        
        \\( \\text{Unicità. Procediamo per induzione di seconda forma.} \\)
        
        \\( \\textbf{passo base: n = 0 }\\)
        \\( \\text{Se } n = 0 \\text{ allora tutti gli addendi della sommatoria saranno nulli } \\implies \\varepsilon_i = 0 \\forall i \\in \\mathbb{N}. \\)
        
        \\( \\textbf{Passo induttivo} \\)
        \\(\\boldsymbol{n \\geq 1, \\forall k < n \\implies n} \\)
        \\( \\text{Sia } n > 0. \\text{ Assumiamo l'asserto sia vero } \\forall k < n \\text{ e dimostriamo che } P(n) \\text{ è verificata } \\forall n \\in \\mathbb{N}. \\)
        \\( \\text{Assumiamo esistano } \\{ \\varepsilon_i \\}_{i \\in \\mathbb{N}}, \\{ \\varepsilon_i' \\}_{i' \\in \\mathbb{N}} \\text{ con le proprietà (1), (2), (3).} \\text{ Proviamo che } \\varepsilon_i = \\varepsilon_i' \\forall i \\in \\mathbb{N}. \\text{ Osserviamo che:} \\)
        \\( n = \\sum_{i \\in \\mathbb{N}} \\varepsilon_i b^i = \\varepsilon_0 + b \\left( \\sum_{i \\geq 1} \\varepsilon_i b^{i-1} \\right) \\)
        \\( n = \\sum_{i \\in \\mathbb{N}} \\varepsilon_i' b^i = \\varepsilon_0' + b \\left( \\sum_{i \\geq 1} \\varepsilon_i' b^{i-1} \\right) \\)
        
        \\( \\text{Osserviamo che } \\varepsilon_0' \\text{ e } \\varepsilon_0 \\text{ sono i resti delle divisioni di } n \\text{ per } b. \\)
        \\( \\text{Per l'unicità della divisione euclidea, } \\varepsilon_0' = \\varepsilon_0. \\text{ Stesso discorso per i quozienti, che inoltre risultano per definizione } \\leq n. \\)
        \\( \\text{Segue, cambiando gli indici della sommatoria:} \\)
        \\( q = \\sum_{j \\geq 1} \\varepsilon_{j+1} b^j = \\sum_{j \\in \\mathbb{N}} \\varepsilon_{j+1} b^j < n \\)
        \\( \\text{Come prima si ha } q < n \\text{ e per ipotesi di induzione si ha che } \\varepsilon_i = \\varepsilon_i' \\forall i \\geq 1. \\)
        """
    }
    
    func detailText4() -> String {
        return """
        \\( \\textbf{Teorema 5} \\text{ (Esistenza e unicità del Massimo Comune Divisore). Siano } n, m \\in \\mathbb{N} \\text{ con } n, m \\text{ non entrambi nulli. Diremo che un } d \\in \\mathbb{N}, d \\geq 1 \\text{ è Massimo Comune Divisore (M.C.D.) di } n, m \\text{ se:} \\)
        
        \\( 1. \\ d \\mid m \\land d \\mid n \\)
        \\( 2. \\ c \\mid m \\land c \\mid n \\implies c \\mid d \\text{ per qualche } c \\in \\mathbb{N}. \\)
        
        \\( \\text{Inoltre, } \\exists x, y \\in \\mathbb{Z} : d = xn + ym, \\text{ ovvero } d \\text{ è esprimibile come combinazione lineare di } n, m \\text{ con } x, y. \\text{ Se } \\exists \\ MCD \\text{ tra } n, m, \\text{ è unico e lo indicheremo con } (n, m). \\)
        
        \\( \\text{Unicità. Poniamo } \\exists d_1, d_2 \\text{ entrambi MCD di } n, m. \\text{ Applicando la proprietà (1) di } d_1 \\text{ e la (2) di } d_2 \\text{ otteniamo:} \\)
        
        \\[
        (1) \\quad d_1 \\mid m \\land d_1 \\mid n \\\\
        (2) \\quad \\text{dato } c = d_1, \\ d_1 \\mid m \\land d_1 \\mid n \\implies d_1 \\mid d_2
        \\]
        
        \\( \\text{Applicando l'inverso otteniamo che } d_2 \\mid d_1 \\land d_1 \\mid d_2 \\implies d_1 = \\pm d_2; \\text{ essendo } d_1, d_2 \\in \\mathbb{N}, \\text{ otteniamo che } d_1 = d_2. \\)
        
        \\( \\text{Esistenza. Sia } S := \\{s \\in \\mathbb{Z} \\mid s > 0, s = xn + ym \\text{ per qualche } x, y \\in \\mathbb{Z}\\}. \\text{ Osserviamo che } S \\neq \\emptyset, \\text{ in quanto } nn + mm > 0, nn + mm \\in S. \\text{ Sia } d := \\min S. \\text{ Vale:} \\)
        \\( d \\mid m \\land d \\mid n, \\text{ infatti } \\exists c \\in \\mathbb{Z} : (c \\mid m \\land c \\mid n \\implies c \\mid d) \\)
        
        \\( \\text{Essendo } d \\in S, d = xn + ym \\text{ per qualche } x, y \\in \\mathbb{Z}. \\text{ Dalla proprietà 2 si ha che } c \\mid xn + ym. \\text{ Dimostriamo che } d \\mid n. \\text{ Eseguendo la divisione euclidea tra } n, d \\text{ otteniamo:} \\)
        \\( n = dq + r, \\ 0 \\leq r < |d| \\)
        \\( \\text{Proviamo per assurdo che } r \\neq 0. \\text{ Se fosse } r > 0, \\text{ avremmo che } r \\in S \\text{ (quindi risulterebbe che } d \\mid r \\text{ non è } \\min S, \\text{ in quanto } d > r). \\text{ Vale:} \\)
        \\( r = n - qd = n - q(xn + ym) \\)
        \\( = n - qnx - qmy \\)
        \\( = n(1 - qx) + m(-qy) \\)
        
        \\( \\text{Allora } r \\in S, \\text{ ma ciò è assurdo perché } r < d = \\min S. \\text{ Quindi } r = 0 \\implies d \\mid n. \\text{ Analogamente si dimostra } d \\mid m. \\)
        
        \\( \\textbf{Teorema 6} \\text{ (Esistenza e unicità del minimo comune multiplo). Siano } n, m \\in \\mathbb{N}. \\text{ Diremo che un } M \\in \\mathbb{N} \\text{ è minimo comune multiplo di } n, m \\text{ se:} \\)
        
        \\( 1. \\ n \\mid M \\land m \\mid M \\)
        \\( 2. \\ n \\mid c \\land m \\mid c \\implies M \\mid c \\text{ per qualche } c \\in \\mathbb{N}. \\)
        
        \\( \\text{Se esiste, è unico e lo indicheremo come } [n, m]. \\text{ Inoltre, se } n, m \\text{ non sono entrambi nulli, vale:} \\)
        \\( [n, m] = \\frac{nm}{(n, m)} \\)
        
        \\( \\text{Se } n, m = 0, \\text{ allora } [n, m] = 0. \\)
        
        \\( \\text{Unicità. Supponiamo esistano } M_1, M_2 \\in \\mathbb{N} : M_1, M_2 \\text{ sono entrambi mcm di } n, m. \\text{ Applicando la proprietà (1) di } M_1 \\text{ e la (2) di } M_2 \\text{ otteniamo:} \\)
        
        \\[
        (1) \\quad n \\mid M_1 \\land m \\mid M_1 \\\\
        (2) \\quad \\text{con } c = M_1, \\ n \\mid M_1 \\land m \\mid M_1 \\implies M_2 \\mid M_1
        \\]
        
        \\( \\text{Invertendo le proprietà si ha che } M_1 \\mid M_2 \\land M_2 \\mid M_1 \\implies M_2 = \\pm M_1. \\text{ Essendo } M_1, M_2 \\in \\mathbb{N}, M_2 = M_1. \\)
        
        \\( \\text{Esistenza. Supponiamo } n, m \\text{ non entrambi nulli. Osservo che} \\)
        \\( (n, m) \\mid n \\iff n = r'(n, m) \\text{ per qualche } r' \\in \\mathbb{Z} \\)
        \\( (n, m) \\mid m \\iff m = s'(n, m) \\text{ per qualche } s' \\in \\mathbb{Z} \\)
        
        \\( \\text{Definisco } M := \\frac{nm}{(n, m)}. \\text{ Sostituendo si ha che} \\)
        
        \\[
        \\frac{nm}{(n, m)} = \\frac{n'r'(n, m)m(n, m)}{(n, m)} \\implies n'r'(n, m) = n'r'(n, m) \\implies n'r' = nm
        \\]
        
        \\( \\text{Allora } n \\mid M, m \\mid M. \\text{ Sia ora } c \\in \\mathbb{Z}. \\text{ Verifichiamo la (2), ovvero che } n \\mid c \\land m \\mid c \\implies M \\mid c. \\text{ Vale:} \\)
        
        \\[
        (n, m) \\mid n, n \\mid c \\implies (n, m) \\mid c \\\\
        (n, m) \\mid m, m \\mid c \\implies (n, m) \\mid c
        \\]
        
        \\( \\text{Allora } c = c'(n, m) \\text{ per qualche } c' \\in \\mathbb{Z}. \\text{ Sappiamo infine che } (n', m') = 1; \\text{ per definizione abbiamo che } n' \\mid c' \\land m' \\mid c' \\implies n'm' \\mid c'. \\text{ Moltiplicando e sinistra a destra si ottiene} \\)
        
        \\[
        n'm' \\left( \\frac{(n, m)}{c'(n, m)} \\right) = c'(n, m) \\left( \\frac{(n, m)}{c'(n, m)} \\right)
        \\]
        """
    }
    
    func detailText5() -> String {
        return """
        \\( \\textbf{Teorema 7} \\text{ (Teorema fondamentale dell'aritmetica). Ogni } n \\in \\mathbb{N}, n \\geq 2 \\text{ si può scrivere come prodotto finito di numeri primi:} \\)
        
        \\[
        n = p_1 p_2 p_3 \\cdots p_k \\quad p_1, p_2, \\cdots, p_k \\in \\mathbb{N} \\text{ primi eventualmente ripetuti}
        \\]
        
        \\( \\text{Tale scrittura è unica a meno di permutazioni. Se} \\)
        
        \\[
        n = q_1 q_2 q_3 \\cdots q_h \\quad q_1, q_2, \\cdots, q_h \\in \\mathbb{N} \\text{ primi eventualmente ripetuti}
        \\]
        
        \\( \\text{Allora } k = h \\text{ ed } \\exists \\varphi : \\{1, 2, \\ldots, k\\} \\mapsto \\{1, 2, \\ldots, h\\}, \\text{ una bigezione (ovvero una permutazione su } \\{1, 2, \\ldots, k\\}) \\text{ tale che:} \\)
        
        \\[
        p_i = q_{\\varphi(i)} \\quad \\forall i \\in \\{1, 2, \\ldots, k\\}
        \\]
        
        \\( \\text{Esistenza. Procediamo per induzione di seconda forma.} \\)
        
        \\( n = 2 \\)
        \\( \\text{Abbiamo che } 2 = 2. \\)
        
        \\( n \\geq 2, \\forall k < n \\implies n \\)
        \\( \\text{Se } n \\text{ è primo, abbiamo finito. Altrimenti possiamo ipotizzare } n = d_1, d_2 : \\ 1 < d_1 < n, \\ 1 < d_2 < n, \\text{ dove} \\)
        
        \\[
        d_1 = p_1 p_2 p_3 \\cdots p_k \\\\
        d_2 = p_1' p_2' p_3' \\cdots p_k'
        \\]
        
        \\( \\text{per ipotesi di induzione. Allora } n \\text{ è fattorizzabile perché prodotto di numeri primi positivi.} \\)
        
        \\( \\text{Unicità. Supponiamo che esistano due distinte fattorizzazioni:} \\)
        
        \\[
        n = p_1 p_2 p_3 \\cdots p_k \\\\
        n = q_1 q_2 q_3 \\cdots q_h
        \\]
        
        \\( \\text{con } h \\geq k. \\text{ Procediamo per induzione di prima forma.} \\)
        
        \\( k = 1 \\)
        \\( \\text{Vale } p_1 = n = q_1 q_2 \\cdots q_h \\text{ con } h \\geq 1. \\text{ Dimostriamo che } h = 1. \\text{ Ipotizziamo per assurdo che } h \\geq 2; \\text{ avremmo che } n = q_1 q_2 \\cdots q_h. \\text{ Sappiamo che essendo } p_1 \\text{ primo, deve necessariamente essere } q_j = 1 \\text{ o } q_j = p_1; \\text{ tuttavia per ipotesi abbiamo che } q_j > 1 \\implies q_j = p_1. \\text{ Allora si ha che} \\)
        
        \\[
        p_1 = n = q_1 q_2 \\cdots q_h \\geq q_1 q_2 = p_1^2 > p_1 = n
        \\]
        
        \\( \\text{che è un assurdo } (n \\not\\leq n). \\text{ Allora } h = 1. \\)
        
        \\( k \\geq 2, k \\implies k + 1 \\)
        \\( \\text{Con } k > 1, \\text{ assumiamo l'asserto vero per } k \\ (n = p_1 p_2 \\cdots p_k = q_1 q_2 \\cdots q_h \\text{ con } h = k, p_i = q_i \\forall i \\in \\mathbb{N} \\text{ a meno di permutazioni}) \\text{ e dimostriamolo per } k + 1 = h. \\text{ Supponiamo quindi che} \\)
        
        \\[
        p_1 p_2 \\cdots p_k p_{k+1} = q_1 q_2 \\cdots q_h \\text{ con } h > k + 1. \\text{ Abbiamo che } p_{k+1} \\mid n \\implies p_{k+1} \\mid q_1 q_2 \\cdots q_h, \\text{ allora } p_{k+1} \\mid q_h \\text{ per ipotesi; essendo } p_{k+1}, q_h \\text{ primi positivi, vale } p_{k+1} = q_h. \\text{ Ma allora} \\)
        
        \\[
        p_1 p_2 \\cdots p_k = q_1 q_2 \\cdots q_{h-1}
        \\]
        
        \\( \\text{dove entrambi i membri sono stati divisi per } p_{k+1}. \\text{ Ma allora per ipotesi d'induzione le due fattorizzazioni hanno lo stesso numero d'elementi, ovvero} \\)
        
        \\[
        k = h - 1, \\ p_{e p_1} = q_1, p_2 = q_2, \\cdots, p_{k+1} = q_h
        \\]
        """
    }
    
    func detailText6() -> String {
        return """
        \\( \\textbf{Teorema 8} \\text{ (Teorema cinese del resto). Siano } n, m \\in \\mathbb{N}; a, b \\in \\mathbb{Z}. \\text{ Consideriamo il seguente sistema di congruenze:} \\)
        
        \\[
        S = \\begin{cases}
        x \\in \\mathbb{Z} \\\\
        x \\equiv a \\pmod{n} \\quad \\quad (1) \\\\
        x \\equiv b \\pmod{m} \\quad \\quad (2)
        \\end{cases}
        \\]
        
        \\( \\text{Definiamo } Sol(S) := \\{x \\in \\mathbb{Z} \\mid (1), (2) \\text{ sono verificate}\\}. \\text{ Sol}(S) \\neq \\emptyset \\iff S \\text{ è compatibile } \\iff (n, m) \\mid (a - b). \\text{ Se } S \\text{ è compatibile, data } c \\in \\mathbb{Z} \\text{ soluzione particolare di } S, \\text{ vale:} \\)
        
        \\[
        Sol(S) = [c]_{[n, m]} = \\{c + k[n, m] \\mid k \\in \\mathbb{Z} \\}
        \\]
        
        \\( \\text{Dimostrazione (compatibilità).} \\)
        
        \\( (\\implies) \\text{Supponiamo } Sol(S) \\neq \\emptyset. \\text{ Sia } c \\in Sol(S). \\text{ Dimostriamo che valgono (1), (2), ovvero } c \\equiv a \\pmod{n} \\land c \\equiv b \\pmod{m}. \\text{ Riscriviamo il sistema di congruenze come:} \\)
        
        \\[
        c = a + kn \\text{ per qualche } k \\in \\mathbb{Z} \\\\
        c = b + hm \\text{ per qualche } h \\in \\mathbb{Z}
        \\]
        
        \\( \\text{Sottraendo membro a membro otteniamo:} \\)
        
        \\[
        (a - b) + (kn - hm) = 0 \\implies hm - kn = a - b
        \\]
        
        \\( \\text{Sappiamo che } (n, m) \\mid n \\land (n, m) \\mid m \\implies (n, m) \\mid [(an + bm)] \\text{ dove } an + bm \\text{ è una combinazione lineare di } n, m \\text{ con qualche } a, b \\in \\mathbb{Z}. \\text{ Allora } (n, m) \\mid (hm - km) = (a - b). \\)
        
        \\((\\impliedby) \\text{Ora supponiamo } (n, m) \\mid (a - b) \\text{ sia vera, ovvero } a - b = k(n, m) \\text{ per qualche } k \\in \\mathbb{Z}. \\text{ Applichiamo l'Algoritmo di Euclide a ritroso, ottenendo } (n, m) = xn + ym \\text{ per qualche } x, y \\in \\mathbb{Z}. \\text{ Segue che:} \\)
        
        \\[
        a - b = kxn + kym \\implies \\frac{a + (-kx)n}{c} = b + (ky)m \\text{ per qualche } x, y \\in \\mathbb{Z}
        \\]
        
        \\( \\text{Dimostrazione (insieme delle soluzioni).} \\)
        
        \\( \\text{Supponiamo infine } Sol(S) \\neq \\emptyset, \\text{ ovvero che il sistema di congruenze è verificato. Sia } c \\in Sol(S). \\text{ Dimostriamo che } Sol(S) = [c]_{[n, m]} \\text{ verificando che uno contiene l'altro e viceversa.} \\)
        
        \\[
        (Sol(S) \\supseteq [c]_{[n, m]}). \\text{ Sia } c' \\in [c]_{[n, m]}, \\text{ allora } c' = c + k[n, m] \\text{ per qualche } k \\in \\mathbb{Z}. \\text{ Riscrivo il sistema come} \\\\
        S = \\begin{cases}
        [c]_n = [a]_n \\\\
        [c]_m = [b]_m
        \\end{cases}
        \\]
        
        \\( \\text{Vale:} \\)
        
        \\[
        [c']_n = [c + k[n,m]]_n \\\\
        = [c]_n + [k]_n [[n,m]]_n \\\\
        = [a]_n + [k]_n [0]_n \\quad \\text{(multiplo di } n)
        \\]
        
        \\( \\text{Con un procedimento analogo si ottiene } [c']_m = [b]_m. \\)
        
        \\[
        (Sol(S) \\subseteq [c]_{[n, m]}). \\text{ Sia } c' \\in Sol(S). \\text{ Vale:} \\\\
        c = a + hn = b + km \\\\
        c' = a + h'n = b + k'm
        \\]
        
        \\( \\text{per qualche } h, h', k, k' \\in \\mathbb{Z}. \\text{ Sottraendo membro a membro:} \\)
        
        \\[
        c' - c = (h' - h)n = (k' - k)m \\\\
        \\implies n \\mid (c' - c), m \\mid (c' - c) \\implies [n, m] \\mid (c' - c)
        \\]
        
        \\( \\implies c' = [c]_{[n, m]} \\)
        """
    }
    
    
    func detailText7() -> String {
        return """
        \\( \\textbf{Definizione (Formula di Eulero).} \\text{ Sia } n \\in \\mathbb{N}, n \\geq 2 : n = p_1^{m_1} p_2^{m_2} \\cdots p_k^{m_k} \\text{ con } p_1, \\cdots, p_k \\text{ primi a due a due distinti. Vale:} \\)
        
        \\[
        \\phi(n) = \\phi(p_1^{m_1}) \\phi(p_2^{m_2}) \\cdots \\phi(p_k^{m_k}) = (p_1^{m_1} - p_1^{m_1-1})(p_2^{m_2} - p_2^{m_2-1}) \\cdots (p_k^{m_k} - p_k^{m_k-1})
        \\]
        
        \\( \\textbf{Lemma.} \\text{ Siano } \\alpha, \\beta \\in (\\mathbb{Z}/n\\mathbb{Z})^*. \\text{ Allora:} \\)
        
        \\(1. \\ \\forall \\alpha, \\beta \\in (\\mathbb{Z}/n\\mathbb{Z})^*, \\ (\\alpha\\beta)^{-1} = \\beta^{-1}\\alpha^{-1} \\)
        \\(2. \\ \\forall \\alpha^{-1} \\in (\\mathbb{Z}/n\\mathbb{Z})^*, \\ (\\alpha^{-1})^{-1} = \\alpha \\)
        
        \\( \\text{Dimostrazione. Vale:} \\)
        
        \\(1. \\ (\\alpha\\beta)(\\beta^{-1}\\alpha^{-1}) = \\alpha(\\beta\\beta^{-1})\\alpha^{-1} = \\alpha[1]_n\\alpha^{-1} = \\alpha\\alpha^{-1} = [1]_n \\)
        \\(2. \\ (\\alpha)(\\alpha^{-1}) = [1]_n \\)
        
        \\( \\textbf{Teorema 9} \\text{ (Teorema di Fermat-Eulero). Sia } n > 0. \\forall[a]_n \\in (\\mathbb{Z}/n\\mathbb{Z})^*, \\text{ vale:} \\)
        
        \\[
        [a]^{\\phi(n)}_n = [1]_n
        \\]
        
        \\( \\text{Equivalente:} \\)
        
        \\[
        a^{\\phi(n)} \\equiv 1 \\pmod{n}, \\ \\forall a \\in \\mathbb{Z}, \\text{ con } (a, n) = 1
        \\]
        
        \\( \\text{Dimostrazione. Definiamo:} \\)
        
        \\[
        L_{\\alpha} : (\\mathbb{Z}/n\\mathbb{Z})^* \\to (\\mathbb{Z}/n\\mathbb{Z})^* \\\\
        \\beta \\mapsto \\alpha\\beta
        \\]
        
        \\(L_{\\alpha} \\text{ è ben definita per il lemma precedente. Proviamo che } L_{\\alpha} \\text{ è una bigezione. Mostriamo che è iniettiva (la suriettività è dimostrata perché gli insiemi di partenza e arrivo coincidono, conseguenza del Lemma dei Cassetti). Supponiamo } \\exists \\beta_1, \\beta_2 \\in (\\mathbb{Z}/n\\mathbb{Z})^*: \\)
        
        \\[
        \\alpha\\beta_1 = L_{\\alpha}(\\beta_1) = L_{\\alpha}(\\beta_2) = \\alpha\\beta_2 \\\\
        \\implies \\beta_1 = (\\alpha^{-1}\\alpha)\\beta_1 = (\\alpha^{-1}\\alpha)\\beta_2 = (\\alpha^{-1}\\alpha)\\beta_2 = \\beta_2
        \\]
        
        \\( \\text{Siano ora } \\{\\beta_1, \\beta_2, \\cdots, \\beta_k\\} \\text{ tutti gli elementi di } (\\mathbb{Z}/n\\mathbb{Z})^*, \\text{ con } k = \\phi(n). \\text{ Applichiamo } L_{\\alpha}: \\)
        
        \\[
        \\{\\alpha\\beta_1, \\alpha\\beta_2, \\cdots, \\alpha\\beta_k\\} = \\{L_{\\alpha}(\\beta_1), L_{\\alpha}(\\beta_2), \\cdots, L_{\\alpha}(\\beta_k)\\}
        \\]
        
        \\( \\text{Essendo } L_{\\alpha} \\text{ una bigezione, ovvero una permutazione su } (\\mathbb{Z}/n\\mathbb{Z})^*, \\text{ abbiamo che } L_{\\alpha}(\\beta_1), L_{\\alpha}(\\beta_2), \\cdots, L_{\\alpha}(\\beta_k) \\text{ appartengono ancora a } (\\mathbb{Z}/n\\mathbb{Z})^* \\text{ e possiamo scrivere, grazie alla proprietà commutativa del prodotto:} \\)
        
        \\[
        \\beta_1\\beta_2 \\cdots \\beta_k = L_{\\alpha}(\\beta_1)L_{\\alpha}(\\beta_2) \\cdots L_{\\alpha}(\\beta_k)
        \\]
        
        \\( \\text{Moltiplicando a destra e a sinistra per } \\beta_k^{-1}\\beta_{k-1}^{-1}\\cdots\\beta_1^{-1} \\text{ si ottiene:} \\)
        
        \\[
        \\alpha^k = \\alpha^{\\phi(n)} = 1
        \\]
        
        \\( \\textbf{Definizione. Siano } n > 0, m > 0. \\text{ Definiamo:} \\)
        
        \\[
        P_m : (\\mathbb{Z}/n\\mathbb{Z})^* \\to (\\mathbb{Z}/n\\mathbb{Z})^* \\\\
        \\alpha \\mapsto \\alpha^m
        \\]
        
        \\( \\text{ovvero } P_m(\\alpha) := \\alpha^m \\ \\forall \\alpha \\in (\\mathbb{Z}/n\\mathbb{Z})^*. \\ P_m \\text{ è ben definita grazie al Lemma precedente.} \\)
        
        \\( \\textbf{Teorema 10} \\text{ (Teorema fondamentale della crittografia RSA). Sia } c > 0 : (c, \\phi(n)) \\leq 1 \\text{ con } n \\text{ fissato; } d > 0 : d \\in [c]_{\\phi(n)}^{-1}. \\text{ Allora la funzione } P_c \\text{ (analoga a } P_m \\text{ nella Definizione precedente) è invertibile e la sua inversa è } P_d. \\)
        
        \\( \\text{Dimostrazione. Sia } \\alpha \\in (\\mathbb{Z}/n\\mathbb{Z})^*. \\text{ Osserviamo che:} \\)
        
        \\[
        [d]_{\\phi(n)}[c]_{\\phi(n)} = [dc]_{\\phi(n)} = [1]_{\\phi(n)} \\\\
        \\iff dc \\equiv 1 \\pmod{\\phi(n)} \\\\
        \\iff dc = 1 + k\\phi(n) \\text{ per qualche } k \\in \\mathbb{Z}
        \\]
        
        \\( \\text{Applicando contemporaneamente } P_c \\text{ e } P_d \\text{ otteniamo che} \\)
        
        \\[
        P_d(P_c(\\alpha)) = (\\alpha^c)^d = \\alpha^{cd} = \\alpha^{1+k\\phi(n)} = \\alpha(\\alpha^{\\phi(n)})^k = \\alpha
        \\]
        
        \\( \\text{Per il Teorema di Fermat-Eulero ciò è equivalente a } \\alpha \\cdot 1^k = \\alpha. \\text{ Allo stesso modo dimostro che } P_c(P_d(\\beta)) = \\beta. \\)
        """
    }
    
    func detailText8() -> String {
        return """
        \\( \\textbf{Teorema 11} \\text{ (Teorema di equivalenza tra la congiungibilità con cammini e congiungibilità con passeggiate). Siano } G = (V, E); v, w \\in V(G). \\text{ Allora } v, w \\text{ sono congiungibili tramite cammini se e solo se sono congiungibili tramite passeggiate.} \\)
        
        \\( \\text{Dimostrazione.} \\)
        
        \\((\\implies). \\text{ Banale. Il cammino è una passeggiata per definizione.} \\\\
        (\\impliedby). \\text{ Supponiamo esista una passeggiata } P \\text{ che congiunge } v, w. \\text{ Sia } \\mathcal{P} \\text{ l'insieme di tutte le passeggiate che congiungono } v, w. \\text{ Osserviamo che } \\mathcal{P} \\neq \\emptyset \\ (P \\in \\mathcal{P}). \\text{ Sia } A := \\{\\mathcal{L}(\\overline{P}) \\in \\mathbb{N} \\mid \\overline{P} \\in \\mathcal{P}\\}. \\text{ Abbiamo che } A \\neq \\emptyset, \\text{ infatti } \\mathcal{L}(P) \\in A. \\)
        
        \\( \\text{Grazie al teorema del buon ordinamento } (\\mathbb{N}, \\leq), \\text{ vale:} \\)
        
        \\[
        \\exists \\min A = m \\implies \\exists P_0 \\in \\mathcal{P} : \\mathcal{L}(P_0) = m \\leq \\mathcal{L}(\\overline{P}), \\forall \\overline{P} \\in \\mathcal{P}
        \\]
        
        \\( \\text{ovvero esiste } \\min A, \\text{ quindi esiste una passeggiata } P \\text{ con il minimo numero di lati. Proviamo ora che } P_0 \\text{ è un cammino in } G. \\text{ Vale:} \\)
        
        \\[
        P_0 = (v_0, v_1, \\ldots, v_n) \\quad v = v_0, \\ w = v_n
        \\]
        
        \\( \\text{Poniamo per assurdo che } P_0 \\text{ non sia un cammino, ovvero } \\exists i, j \\in \\{0, 1, \\ldots, n\\} : i < j, v_i = v_j. \\text{ Definiamo } P_1 := (v_0, v_1, \\ldots, v_{i-1}, v_i, v_{j+1}, \\ldots, v_n) \\in \\mathcal{P} \\text{ (ovvero } P_0 \\text{ alla quale sono stati tolti tutti i vertici tra } i \\text{ e } j). \\text{ Vale:} \\)
        
        \\[
        \\mathcal{L}(P_1) = \\mathcal{L}(P_0) - (j - i) = m - (j - i) < m
        \\]
        
        \\( \\text{Ma ciò è assurdo in quanto } P_0 \\text{ è già per definizione un cammino con il minimo numero di lati.} \\)
        
        \\( \\textbf{Teorema 12} \\text{ (La relazione di congiungibilità è una relazione di equivalenza). Dato } G = (V, E) \\text{ la relazione di congiungibilità in } G \\text{ su } V \\text{ è una relazione di equivalenza su } V: \\)
        
        \\(1. \\ \\text{(riflessività)} \\quad u \\sim u \\quad \\forall u \\in V \\)
        \\(2. \\ \\text{(simmetria)} \\quad (u \\sim v) \\implies (v \\sim u) \\quad \\forall u, v \\in V \\)
        \\(3. \\ \\text{(transitività)} \\quad (u \\sim v) \\land (v \\sim w) \\implies (u \\sim w) \\quad \\forall u, v, w \\in V \\)
        
        \\( \\text{Indicheremo la relazione d’equivalenza con } \\sim. \\)
        
        \\( \\text{Dimostrazione. Siano } u, v, w \\in V, \\sim \\text{ la relazione d’equivalenza. Vale:} \\)
        
        \\(1. \\ \\text{è vera in quanto } (u) \\text{ è un cammino che congiunge } u \\text{ a } u. \\)
        \\(2. \\ \\text{è vera in quanto se } u \\sim v \\text{ esiste una passeggiata } P = (v_0, \\ldots, v_n) \\text{ tale che } u = v_0 \\text{ e } v = v_n. \\text{ Ma allora } P' = (v_n, v_{n-1}, \\ldots, v_0) \\text{ è una passeggiata, dove vertici consecutivi in } P \\text{ lo sono anche in } P' \\text{ (anche se in ordine inverso).} \\)
        \\(3. \\ \\text{è vera in quanto se } u \\sim v \\text{ e } v \\sim w \\text{ allora esistono due passeggiate } P_1 = (v_0, \\ldots, v_n), P_2 = (w_0, \\ldots, w_m) \\text{ dove } u = v_0, v = v_n = w_0, w = w_m. \\text{ Possiamo definire una terza passeggiata } P_3 = (v_0, \\ldots, v_n, w_1, \\ldots, w_m) \\text{ costruita come unione delle precedenti; } P_3 \\text{ è una passeggiata in quanto vertici consecutivi in } P_3 \\text{ lo sono o in } P_1 \\text{ o in } P_2, \\text{ e i primi e ultimi vertici della passeggiata sono rispettivamente } u \\text{ e } w. \\)
        """
    }
    
    func detailText9() -> String {
        return """
        \\( \\textbf{Teorema 13} \\text{ (Relazione fondamentale tra } |E(G)| \\text{ e } deg(v) \\text{ in un grafo finito). Sia } G = (V, E) \\text{ un grafo finito. Vale:} \\)
        
        \\[
        2 \\cdot |E| = \\sum_{v \\in V} deg_G(v)
        \\]
        
        \\( \\text{Dimostrazione. Siano } v_1, v_2, \\ldots, v_n \\text{ i vertici di } G, e_1, e_2, \\ldots, e_k \\text{ i lati di } G \\text{ (dove } k := |E|). \\text{ Sia} \\)
        
        \\[
        M_{ij} := \\begin{cases}
        0 & \\text{se } v_i \\notin e_j \\quad \\forall i \\in \\{1, 2, \\ldots, n\\} \\\\
        1 & \\text{se } v_i \\in e_j \\quad \\forall j \\in \\{1, 2, \\ldots, k\\}
        \\end{cases}
        \\]
        
        \\( \\text{dove } i \\text{ rappresenta l’indice sul numero dei vertici e } j \\text{ l’indice sul numero dei lati. Vale, grazie alla proprietà commutativa delle somme:} \\)
        
        \\[
        \\sum_{i=1}^{n} \\sum_{j=1}^{k} m_{ij} = \\sum_{j=1}^{k} \\sum_{i=1}^{n} m_{ij}
        \\]
        
        \\( \\text{dove (1) rappresenta una somma di sommatorie con un vertice } i \\text{ fissato; in ciascuna somma, si somma 1 se un lato contiene il vertice fissato, 0 se ciò non accade. Ma ciò non è altro che il grado del dato vertice; (2) invece somma } k \\text{ volte una sommatoria con un lato } j \\text{ fissato, dove viene sommato 1 tante volte quante un vertice appartiene a un dato lato, ovvero 2. Infine vale:} \\)
        
        \\[
        \\sum_{v \\in V} deg(v) = 2k = 2|E|
        \\]
        
        \\( \\textbf{Teorema 14} \\text{ (Lemma delle strette di mano). In un grafo } G = (V, E) \\text{ finito il numero di vertici di grado dispari è pari.} \\)
        
        \\( \\text{Dimostrazione. Sia } G = (V, E). \\text{ Vale, grazie alla relazione fondamentale tra lati e gradi di un grafo:} \\)
        
        \\[
        2|E| = \\sum_{v \\in V} deg(v) = \\sum_{deg(v) \\text{ pari}} deg(v) + \\sum_{deg(v) \\text{ dispari}} deg(v)
        \\]
        
        \\( \\text{Allora la somma dei vertici con grado dispari deve essere pari perché differenza di un numero pari e una somma di numeri pari:} \\)
        
        \\[
        2|E| - \\sum_{deg(v) \\text{ pari}} deg(v) = \\sum_{deg(v) \\text{ dispari}} deg(v)
        \\]
        
        \\( \\text{e ciò accade solo se il numero di elementi dispari sommati è pari.} \\)
        """
    }
    
    func detailText10() -> String {
        return """
        \\( \\textbf{Teorema 15} \\text{ (Teorema di caratterizzazione degli alberi finiti mediante la formula di Eulero). Sia } T = (V, E) \\text{ un grafo finito. Le seguenti affermazioni sono equivalenti:} \\)
        
        1. \\( T \\text{ è un albero} \\)
        
        2. \\( \\forall v, v' \\in V, \\exists! \\text{ cammino da } v \\text{ in } v' \\)
        
        3. \\( T \\text{ è connesso e } \\forall e \\in E, \\ T - e := (V, E \\setminus \\{e\\}) \\text{ è sconnesso} \\)
        
        4. \\( T \\text{ non ha cicli e } \\forall e \\in \\binom{V}{2} \\setminus E, \\ T + e := (V, E \\cup \\{e\\}) \\text{ ha almeno un ciclo} \\)
        
        5. \\( T \\text{ è connesso e } |V| - 1 = |E| \\)
        
        \\( \\text{Dimostrazione.} \\)
        
        \\((1 \\implies 5). \\text{ Procediamo per induzione su } |V(T)|. \\)
        
        \\( |V(T)| = 1 \\) \\
        \\( \\text{Vale } |E(T)| = 0 = |V(T)| - 1. \\)
        
        \\( |V(T)| \\geq 2, |V(T)| - 1 \\implies |V(T)| \\) \\
        \\( \\text{Sia } T \\text{ un qualsiasi albero con } |V(T)| \\geq 2. \\text{ Dimostriamo che vale la proprietà (5). Essendo } T \\text{ un albero, } \\exists \\text{ almeno una foglia } v \\in T. \\text{ Consideriamo ora } T - v: \\text{ è ancora un albero, dove} \\)
        
        \\[
        |V(T - v)| = |V(T)| - 1 \\\\
        |E(T - v)| = |E(T)| - 1
        \\]
        
        \\( \\text{Vale, per ipotesi induttiva:} \\)
        
        \\[
        |V(T - v)| - 1 = |E(T - v)|, \\\\
        |V(T)| - 1 - 1 = |E(T)| - 1 \\\\
        |V(T)| - 1 = |E(T)|
        \\]
        
        \\((1 \\impliedby 5). \\text{ Procediamo per induzione su } |V(T)|. \\)
        
        \\( |V(T)| = 1 \\) \\
        \\( \\text{Un grafo con 1 vertice e 0 lati è un albero per definizione.} \\)
        
        \\( |V(T)| \\geq 2, |V(T)| - 1 \\implies |V(T)| \\) \\
        \\( \\text{Sia } T \\text{ un grafo connesso che soddisfa la formula di Eulero. Supponiamo per assurdo che } T \\text{ non abbia foglie, ovvero che } deg(v) \\geq 2 \\ \\forall v \\in V(T). \\text{ Allora} \\)
        
        \\[
        |V(T)| - 1 = \\frac{1}{2} \\sum_{v \\in V} deg(v)
        \\]
        
        \\( 2 |V(T)| - 2 = \\sum_{v \\in V} deg(v) \\geq 2 |V(T)| \\)
        
        \\( \\text{che è un assurdo. Allora } T \\text{ ha almeno una foglia. Se consideriamo } v \\in V(T) \\text{ foglia, } T - v \\text{ è ancora connesso e vale Eulero. Allora per ipotesi induttiva } T - v \\text{ è un albero } \\implies T \\text{ è un albero.} \\)
        """
    }
    
    func detailText11() -> String {
        return """
        \\( \\textbf{Teorema 16} \\text{ (Teorema di esistenza degli alberi di copertura per un grafo finito). Ogni grafo connesso ammette almeno un albero di copertura.} \\)
        
        \\( \\text{Dimostrazione. Determiniamo} \\)
        
        \\[
        \\mathcal{T} := \\{T \\mid T \\text{ è un sottografo di } G, T \\text{ è un albero}\\}
        \\]
        
        \\( \\text{Sia } T \\in \\mathcal{T} : |V(T)| \\geq |V(T)| \\ \\forall T \\in \\mathcal{T}. \\)
        \\( \\text{Osservo che } T \\neq \\emptyset \\ \\text{in quanto se } v \\in V(G) \\ \\text{allora } (v, \\emptyset) \\in \\mathcal{T}. \\)
        \\( \\text{Proviamo che } V(T) = V(G) \\ \\text{ovvero che } T \\text{ è un albero di copertura.} \\)
        \\( \\text{Usando la connessione di } G, \\ \\text{è possibile determinare un vertice } w \\in V(G) \\setminus V(T) \\ \\text{e un vertice } u \\in V(T) \\ \\text{tali che } \\{u, w\\} \\in E(G). \\)
        \\( \\text{Ma allora possiamo definire} \\)
        
        \\[
        \\overline{T} \\in \\mathcal{T}, \\ \\overline{T} := (V(T) \\cup \\{w\\}, E(T) \\cup \\{u, w\\})
        \\]
        
        \\( \\text{che è chiaramente un albero, ma che va in contraddizione con la massimalità dei vertici di } T. \\)
        """
    }
}

struct DetailView: View {
    let detailText: String
    
    var body: some View {
        WebView(text: detailText)
            .navigationTitle("Enunciato Teorema")
            .navigationBarBackButtonHidden(true)
    }
}

struct WebView: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlString = """
            <!DOCTYPE html>
            <html>
            <head>
            <script type="text/javascript" async
              src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML">
            </script>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                    font-size: 35px;
                    margin: 20px;
                    word-wrap: break-word;
                }
                @media (orientation: landscape) {
                    body {
                        font-size: 20px;
                    }
                }
            </style>
            </head>
            <body>
            \(text)
            </body>
            </html>
            """
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}

#Preview {
    Theorems()
}
