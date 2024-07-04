
# Fondamenti - iOS Application

**Fondamenti** is an iOS application designed to assist users in completing FMI exercises. The application features several buttons, each corresponding to a specific functionality.

## Features

### 1. Congruenze
- **Description**: Solves systems of congruences.
- **User Input**: Coefficients and moduli of two congruences.
- **Process**:
  - Calculates the Greatest Common Divisor (GCD) with back substitution.
  - Computes the Least Common Multiple (LCM).
  - Determines the particular solution (C) and the complete solution (S).
- **Output**: Displays the intermediate steps and the final solution.

### 2. RSA
- **Description**: Performs RSA-related computations.
- **User Input**: Exponent, coefficient, and modulus.
- **Process**:
  - Factorizes the conditions into prime factors.
  - Calculates the GCD with back substitution.
  - Determines the particular solution (d), the orbit, and the maximum negative and minimum positive whole solutions.
- **Output**: Displays the intermediate steps and the final result.

### 3. Isomorfismi
- **Description**: Checks for isomorphisms between graphs.
- **User Input**: 2 or 3 graphs, with edges specified in the format `"x1-x2,x1-x3,...xn-xk"`.
- **Process**:
  - Checks for 6 specific obstructions.
  - Prints any obstructions not verified.
  - Maps the bijection.
  - Verifies the morphism.
- **Output**: Displays the intermediate steps and results for each pair of graphs.

### 4. Score
- **Description**: Analyzes graph scores and specific properties.
- **User Input**: Scores in `ascending order` `("v1,v2,...,vn")`. Options to check if the graph is Hamiltonian, 2-connected, disconnected, or a tree via checkboxes.
- **Process**:
  - Checks for 4 specific obstructions.
  - Prints the obstruction preventing the vector from being a graph.
  - Applies the score theorem.
  - Verifies if the graph meets the selected properties (Note: `Manual verification is recommended for greater accuracy`).
- **Output**: Displays the intermediate steps and the final results.

### 5. Tool Modulo
- **Description**: Calculates the modulus of a given coefficient.
- **User Input**: Coefficient and modulus.
- **Process**: 
  - Computes the modulus of the given coefficient, which can be an expression (e.g., power or multiplication).
- **Output**: Displays the result in the form `modulo * x + result`.

### 6. Teoremi
- **Description**: Shows a list of theorems.
- **Process**: Displays the following list of theorems:
  - Buon ordinamento e seconda forma induzione
  - Esistenza e unicità divisione euclidea
  - Unicità numero base arbitraria
  - Esistenza e unicità MCM, mcd
  - Teorema fondamentale dell'aritmetica
  - Teorema cinese del resto
  - Teorema di Fermat-Eulero e RSA
  - Teoremi congiungibilità grafi
  - Relazione grafi finiti e lemma strette di mano
  - Teorema caratterizzazione alberi finiti
  - Teorema esistenza alberi copertura

## Installation Instructions

To install the application, follow these steps:

1. Download the project zip file from the Release.
2. Open the project in Xcode.
3. Set your device as the run destination.
4. Build and run the application on your device.

For detailed installation guidance, please refer to the [official Xcode documentation](https://developer.apple.com/documentation/xcode).

---

Feel free to contact us for support or further assistance. Hope the app helps you pass the FMI exam!
