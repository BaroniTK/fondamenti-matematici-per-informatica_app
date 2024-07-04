package com.example.fondamentiapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.example.fondamentiapp.HamiltonianCycle;
import com.example.fondamentiapp.R;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import org.jgrapht.Graph;
import org.jgrapht.Graphs;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleGraph;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.Queue;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

public class Grafi extends AppCompatActivity {

    private TextView resultTextView;
    private TextView processTextView;
    private GraphView graphView,graphView2,graphView3,graphView4;
    private EditText vector1EditText, vector2EditText;
    private CheckBox treeCheckBox, hamiltonianCheckBox, disconnectedCheckBox, twoConnectedCheckBox, threeComponentsCheckBox, connectedCheckBox, forestaCheckBox;
    private Button verifyButton;
    private Integer[] grafoPrimarioD1,grafoPrimarioD2;
    private StringBuilder ostruzioni;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.grafi);

        resultTextView = findViewById(R.id.resultTextView);
        processTextView = findViewById(R.id.processTextView);
        graphView = findViewById(R.id.graphView);
        graphView2=findViewById(R.id.graphView2);
        graphView3= findViewById(R.id.graphView3);
        graphView4=findViewById(R.id.graphView4);
        vector1EditText = findViewById(R.id.vector1EditText);
        vector2EditText = findViewById(R.id.vector2EditText);
        treeCheckBox = findViewById(R.id.treeCheckBox);
        hamiltonianCheckBox = findViewById(R.id.hamiltonianCheckBox);
        forestaCheckBox=findViewById(R.id.forestaCheckBox);
        disconnectedCheckBox = findViewById(R.id.disconnectedCheckBox);
        twoConnectedCheckBox = findViewById(R.id.twoConnectedCheckBox);
        threeComponentsCheckBox = findViewById(R.id.threeComponentsCheckBox);
        connectedCheckBox = findViewById(R.id.connectedCheckBox);
        verifyButton = findViewById(R.id.verifyButton);

        verifyButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ostruzioni = new StringBuilder(); // Inizializza ogni volta che viene premuto il bottone

                String vector1Text = vector1EditText.getText().toString();
                String vector2Text = vector2EditText.getText().toString();

                Integer[] d1;
                Integer[] d2;

                try {
                    d1 = parseVector(vector1Text);
                    d2 = parseVector(vector2Text);
                } catch (NumberFormatException e) {
                    resultTextView.setText("Errore: assicurati di inserire solo numeri separati da virgole.");
                    return;
                }

                StringBuilder processLog1 = new StringBuilder();
                StringBuilder processLog2 = new StringBuilder();

                try {
                    boolean d1Valid = verificaSequenzaGradi(d1, processLog1,true) && verificaOstruzioni(d1, processLog1).isEmpty();
                    boolean d2Valid = verificaSequenzaGradi(d2, processLog2,false) && verificaOstruzioni(d2, processLog2).isEmpty();

                    String result = d1Valid ? "d1: SI\n" : "d1: NO\n";
                    result += d2Valid ? "d2: SI\n" : "d2: NO\n";

                    if (!d1Valid) {
                        result += "Il vettore d1 non è lo score di un grafo: " + ostruzioni +
                                "\nLe quattro ostruzioni viste a lezione non si possono applicare a d2. " +
                                "Applichiamo quindi il teorema dello score a d2, ciò è possibile inquanto " + d2[d2.length - 1] +
                                " <= " + (d2.length - 1) + " = n-1";

                        result += "\n**COPIA IL TEOREMA DELLO SCORE SOTTO**\n Poichè il vettore d2':=" + Arrays.toString(grafoPrimarioD2) + " è lo score di un grafo G'2 seguente: \n **FAI IL GRAFO DELL'ULTIMO PASSAGGIO DELLA RIDUZIONE**\n" +
                                "grazie al teorema dello score, anche d2 è lo score di un grafo. \n Costruisco un grafo G2 con score d2 \n **COPIA I PASSAGGI DEL RITROSO E EVIDENZIA I CAMBIAMENTI**\n Dunque, vale: \n **COPIA IL GRAFO SOTTO**";
                    }

                    if (!d2Valid) {
                        result += "Il vettore d2 non è lo score di un grafo: " + ostruzioni +
                                "\nLe quattro ostruzioni viste a lezione non si possono applicare a d1. " +
                                "Applichiamo quindi il teorema dello score a d1, ciò è possibile inquanto " + d1[d1.length - 1] +
                                " <= " + (d1.length - 1) + " = n-1";

                        result += "\n**COPIA IL TEOREMA DELLO SCORE SOTTO**\n Poichè il vettore d1':=" + Arrays.toString(grafoPrimarioD1) + " è lo score di un grafo G'1 seguente: \n **FAI IL GRAFO DELL'ULTIMO PASSAGGIO DELLA RIDUZIONE**\n" +
                                "grazie al teorema dello score, anche d1 è lo score di un grafo. \n Costruisco un grafo G1 con score d1 \n **COPIA I PASSAGGI DEL RITROSO E EVIDENZIA I CAMBIAMENTI**\n Dunque, vale: \n **COPIA IL GRAFO SOTTO**";
                    }

                    resultTextView.setText(result);
                    processTextView.setText(processLog1.toString() + "\n\n" + processLog2.toString());

                    if (d1Valid) {
                        displayGraphAndProperties(d1, processLog1);
                    }

                    if (d2Valid) {
                        displayGraphAndProperties(d2, processLog2);
                    }
                } catch (Exception e) {
                    resultTextView.setText("Errore: " + e.getMessage());
                }
            }
        });

        BottomNavigationView bottomNavigationView = findViewById(R.id.bottom_navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(item -> {
            int itemID = item.getItemId();
            Intent intent = null;

            if (itemID == R.id.congruenzePotenza) {
                intent = new Intent(Grafi.this, CongruenzaRSA.class);
            } else if (itemID == R.id.tools) {
                intent = new Intent(Grafi.this, Tools.class);
            } else if (itemID == R.id.sistema3) {
                intent = new Intent(Grafi.this, SistemaCongruenze.class);
            } else if (itemID == R.id.isomorfismo) {
                intent = new Intent(Grafi.this, Isomorfismo.class);
            }

            if (intent != null) {
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                return true;
            }
            return false;
        });
        bottomNavigationView.setSelectedItemId(R.id.grafi);
    }

    private String verificaOstruzioni(Integer[] gradi, StringBuilder logProcesso) {
        logProcesso.append("Controllo delle ostruzioni\n");

        int n = gradi.length;

        // Ostruzione 1: l'ultimo elemento deve essere maggiore della lunghezza del vettore - 1
        if (gradi[n - 1] > n - 1) {
            logProcesso.append("Ostruzione 1: verificata. d1 non è lo score di un grafo\n");
            logProcesso.append("Motivo: l'ultimo elemento del vettore (" + gradi[n - 1] + ") è maggiore di " + (n - 1) + "\n");
            ostruzioni.append("Motivo: l'ultimo elemento del vettore (" + gradi[n - 1] + ") è maggiore di " + (n - 1) + "\n");
            return ostruzioni.toString();
        } else {
            logProcesso.append("Ostruzione 1: non verificata. Nulla si può dire\n");
        }
        if(gradi[n-1]==n-1){

            int ultimo1 = gradi[n - 1];
            int penultimo1 = gradi[n - 2];
            if (ultimo1 == penultimo1) {
                int k = 1;
                int lastElement = gradi[n - 1];
                for (int i = n - 2; i >= 0; i--) {
                    if (gradi[i] == lastElement) {
                        k++;
                    } else {
                        break;
                    }
                }
                if (gradi[0] < k) {
                    logProcesso.append("Ostruzione 2: verificata. d1 non è lo score di un grafo\n");
                    logProcesso.append("Motivo: il primo elemento del vettore (" + gradi[0] + ") è minore del valore degli ultimi " + k + " (" + penultimo1 + ")\n");
                    ostruzioni.append("Motivo: il primo elemento del vettore (" + gradi[0] + ") è minore del valore degli ultimi " + k + " (" + penultimo1 + ")\n");
                    return ostruzioni.toString();
                } else {
                    logProcesso.append("Ostruzione 2: non verificata. Nulla si può dire\n");
                }
            }
        }else{
            logProcesso.append("Ostruzione 2: non verificata. Nulla si può dire\n");
        }

        // Controllo aggiuntivo nella seconda ostruzione


        // Ostruzione 3: elimina gli ultimi due elementi e verifica la condizione
        if (n > 2) {
            int ultimo = gradi[n - 1];
            int penultimo = gradi[n - 2];
            int sommaUltimiDue = ultimo + penultimo;
            int countMaggioreUguale2 = 0;
            for (int i = 0; i < n - 2; i++) {
                if (gradi[i] >= 2) {
                    countMaggioreUguale2++;
                }
            }
            if (countMaggioreUguale2 < sommaUltimiDue - n) {
                logProcesso.append("Ostruzione 3: verificata. d1 non è lo score di un grafo\n");
                logProcesso.append("Motivo: il numero di valori rimanenti >= 2 (" + countMaggioreUguale2 + ") è minore della somma degli ultimi due elementi (" + sommaUltimiDue + ") meno la lunghezza del vettore (" + n + ")\n");

                ostruzioni.append("Motivo: il numero di valori rimanenti >= 2 (" + countMaggioreUguale2 + ") è minore della somma degli ultimi due elementi (" + sommaUltimiDue + ") meno la lunghezza del vettore (" + n + ")\n");
                return ostruzioni.toString();
            } else {
                logProcesso.append("Ostruzione 3: non verificata. Nulla si può dire\n");
            }
        }

        // Ostruzione 4: il numero di valori dispari deve essere pari
        long countDispari = Arrays.stream(gradi).filter(d -> d % 2 != 0).count();
        if (countDispari % 2 == 0) {
            logProcesso.append("Ostruzione 4: non verificata. Nulla si può dire\n");
        } else {
            logProcesso.append("Ostruzione 4: verificata. d1 non è lo score di un grafo\n");
            logProcesso.append("Motivo: il numero di valori dispari (" + countDispari + ") NON è pari e questo viola il lemma delle strette di mano\n");
            ostruzioni.append("Motivo: il numero di valori dispari (" + countDispari + ") NON è pari e questo viola il lemma delle strette di mano\n");
            return ostruzioni.toString();
        }
        return "";
    }

    private boolean controllaFine(Integer[] gradi) {
        for (int grado : gradi) {
            if (grado > 2) {
                return false;
            }
        }
        return true;
    }

    private boolean verificaSequenzaGradi(Integer[] gradi, StringBuilder logProcesso,boolean isD1) {
        Arrays.sort(gradi);

        // Condizione 4: Algoritmo di Havel-Hakimi
        logProcesso.append("Sequenza di gradi iniziale (ordinata in ordine crescente): ").append(Arrays.toString(gradi)).append("\n");
        ArrayList<Integer> listaGradi = new ArrayList<>(Arrays.asList(gradi));

        while (!listaGradi.isEmpty()) {
            Collections.sort(listaGradi);
            logProcesso.append("Sequenza ordinata (crescente): ").append(listaGradi).append("\n");

            if (controllaFine(listaGradi.toArray(new Integer[0]))) {
                if(isD1){
                    grafoPrimarioD1 = listaGradi.toArray(new Integer[0]);
                }else{
                    grafoPrimarioD2 = listaGradi.toArray(new Integer[0]);
                }
                logProcesso.append("Tutti i gradi sono <=2, sequenza valida\n");
                return true;
            }

            int d = listaGradi.remove(listaGradi.size() - 1);
            logProcesso.append("Rimosso grado: ").append(d).append("\n");
            if (d > listaGradi.size()) {
                logProcesso.append("Grado ").append(d).append(" è troppo grande\n");
                return false;
            }

            for (int i = listaGradi.size() - 1; i >= listaGradi.size() - d; i--) {
                listaGradi.set(i, listaGradi.get(i) - 1);
            }
            logProcesso.append("Sequenza dopo decremento: ").append(listaGradi).append("\n");
        }

        if (controllaFine(listaGradi.toArray(new Integer[0]))) {
            if(isD1){
                grafoPrimarioD1 = listaGradi.toArray(new Integer[0]);
            }else{
                grafoPrimarioD2 = listaGradi.toArray(new Integer[0]);
            }
            logProcesso.append("Tutti i gradi sono <=2, sequenza valida\n");
            return true;
        }
        return false;
    }

    private void displayGraphAndProperties(Integer[] gradi, StringBuilder logProcesso) {
        Graph<Integer, DefaultEdge> graph;
        try {
            graph = buildGraph(gradi);
            graphView.setGraph(graph);

            if (treeCheckBox.isChecked()) {
                int conta = 0;
                for (int i = 0; i < gradi.length; i++) {
                    if (gradi[i] == 1) {
                        conta++;
                    }
                }
                if (isTree(graph)) {
                    int somma = 0;
                    for (int i = 0; i < gradi.length; i++) {
                        somma += gradi[i];
                    }
                    int formulaEulero = somma / 2;
                    if (formulaEulero == gradi.length - 1) {
                        logProcesso.append("Esiste un albero? SI\nMotivo: Viene rispettata la Formula di eulero: n-1=").append(gradi.length).append("-1=1/2(").append(somma).append(") ==").append(gradi.length).append("-1 Inoltre il grafo ha: ").append(conta).append(" foglie\n");
                        graphView4.setGraph(graph);
                    } else {
                        logProcesso.append("Esiste un albero? NO\nMotivo: NON Viene rispettata la Formula di eulero: n-1=").append(gradi.length).append("-1=1/2(").append(somma).append(") ==").append(gradi.length).append("-1 Inoltre il grafo ha: ").append(conta).append(" foglie\n");
                    }
                } else {
                    int somma = 0;
                    for (int i = 0; i < gradi.length; i++) {
                        somma += gradi[i];
                    }
                    int formulaEulero = somma / 2;
                    if (formulaEulero == gradi.length - 1) {
                        logProcesso.append("Esiste un albero? SI\nMotivo: Viene rispettata la Formula di eulero: n-1=").append(gradi.length).append("-1=1/2(").append(somma).append(") ==").append(gradi.length).append("-1 Inoltre il grafo ha: ").append(conta).append(" foglie\n");
                        graphView4.setGraph(graph);
                    } else {
                        logProcesso.append("Esiste un albero? NO\nMotivo: NON Viene rispettata la Formula di eulero: n-1=").append(gradi.length).append("-1=1/2(").append(somma).append(") ==").append(gradi.length).append("-1 Inoltre il grafo ha: ").append(conta).append(" foglie\n");
                    }
                }
                logProcesso.append("\n");
            }

            String forzatura = Collections.min(Arrays.asList(gradi)) + "+" + Collections.max(Arrays.asList(gradi)) + ">=" + (gradi.length - 1);
            String disconessione = forzaturaDisconnesione(gradi);

            if (disconnectedCheckBox.isChecked()) {
                if (isDisconnected(gradi)) {
                    if (!disconessione.isEmpty()) {
                        logProcesso.append("Esiste un grafo sconnesso? SI\nMotivo: Il controllo della connettività mostra che il grafo non è connesso, il grafo costruito sopra ne è la prova. Inoltre si può verificare la forzatura alla sconnessione: ").append(disconessione).append("\n");
                    } else {
                        logProcesso.append("Esiste un grafo sconnesso? SI\nMotivo: Il controllo della connettività mostra che il grafo non è connesso, il grafo costruito sopra ne è la prova.\n");
                    }
                } else {
                    if (!disconessione.isEmpty()) {
                        logProcesso.append("Esiste un grafo sconnesso? NO\nMotivo: Il controllo della connettività mostra che il grafo è connesso, il grafo costruito sopra ne è la prova. Si può verificare quindi la forzatura alla connessione: ").append(forzatura).append("\n");
                    } else {
                        logProcesso.append("Esiste un grafo sconnesso? NO\nMotivo: Il controllo della connettività mostra che il grafo è connesso, il grafo costruito sopra ne è la prova.\n");
                    }
                }
                logProcesso.append("\n");
            }
            if (connectedCheckBox.isChecked()) {
                if (isConnected(gradi)) {
                    if (forzaturaDiConnessione(gradi)) {
                        logProcesso.append("Esiste un grafo connesso? SI\nMotivo: Il controllo della connettività mostra che il grafo è connesso. Inoltre si può verificare la forzatura di connessione: ").append(forzatura).append("\n");
                    } else {
                        logProcesso.append("Esiste un grafo connesso? NO\nMotivo: Il controllo della connettività mostra che il grafo non è connesso. Inoltre si può verificare la forzatura di connessione: ").append(forzatura).append(" è falsa, Si puo verificare la forzatura alla sconnessione: ").append(disconessione).append("\n");
                    }
                } else {
                    if (forzaturaDiConnessione(gradi)) {
                        logProcesso.append("Esiste un grafo connesso? SI\nMotivo: Il controllo della connettività mostra che il grafo è connesso. Inoltre si può verificare la forzatura di connessione: ").append(forzatura).append("\n");
                    } else {
                        logProcesso.append("Esiste un grafo connesso? NO\nMotivo: Il controllo della connettività mostra che il grafo non è connesso. Inoltre si può verificare la forzatura di connessione: ").append(forzatura).append(" è falsa, Si puo verificare la forzatura alla sconnessione: ").append(disconessione).append("\n");
                    }
                }
                logProcesso.append("\n");
            }
            if (hamiltonianCheckBox.isChecked()) {
                HamiltonianCycle hc = new HamiltonianCycle(graph.vertexSet().size());
                if (hc.hamCycle(convertGraphToAdjMatrix(graph))) {
                    StringBuilder cycleString = new StringBuilder();
                    for (int i = 1; i <= graph.vertexSet().size(); i++) {
                        cycleString.append("v").append(i);
                        if (i < graph.vertexSet().size()) {
                            cycleString.append(", ");
                        }
                    }
                    cycleString.append(", v1");
                    logProcesso.append("Esiste un grafo Hamiltoniano? SI\nMotivo: Il grafo contiene un ciclo Hamiltoniano: ")
                            .append(cycleString.toString()).append("\n");
                } else {
                    boolean out=false;
                    for(int i=0;i<gradi.length;i++){
                        if(gradi[i]==1){
                            out=true;
                        }
                    }logProcesso.append("Esiste un grafo Hamiltoniano? NO\nMotivo: Il grafo non contiene un ciclo Hamiltoniano. ");
                    if (out) {
                        logProcesso.append("Inoltre, gli Hamiltoniani non hanno foglie\n");
                    } else {
                        logProcesso.append("\n");
                    }

                }
                logProcesso.append("\n");
            }

            if (twoConnectedCheckBox.isChecked()) {
                if (is2Connesso(graph)) {
                    boolean outCondition = true;
                    for (int i = 0; i < gradi.length; i++) {
                        if (gradi[i] == 1) {
                            outCondition = false;
                        }
                    }
                    if (outCondition) {
                        logProcesso.append("Esiste un grafo 2-connesso? SI\nMotivo: Il grafo è 2-connesso, non contiene punti di articolazione, Inoltre non sono presenti foglie.\n");
                    } else {
                        logProcesso.append("Esiste un grafo 2-connesso? NO\nMotivo: Il grafo contiene punti di articolazione, inoltre sono presenti foglie cosa impossibile per un grafo 2-connesso.\n");
                    }
                } else {
                    boolean outCondition = true;
                    for (int i = 0; i < gradi.length; i++) {
                        if (gradi[i] == 1) {
                            outCondition = false;
                        }
                    }
                    if (outCondition) {
                        logProcesso.append("Esiste un grafo 2-connesso? SI\nMotivo: Il grafo è 2-connesso, non contiene punti di articolazione, Inoltre non sono presenti foglie.\n");
                    } else {
                        logProcesso.append("Esiste un grafo 2-connesso? NO\nMotivo: Il grafo contiene punti di articolazione, inoltre sono presenti foglie cosa impossibile per un grafo 2-connesso.\n");
                    }
                }
                logProcesso.append("\n");
            }
            if (threeComponentsCheckBox.isChecked()) {
                Integer[] newDegrees = removeDegreeTwo(gradi);
                StringBuilder newProcessLog = new StringBuilder();
                boolean newValid = verificaSequenzaGradi(newDegrees, newProcessLog, false);
                Graph<Integer, DefaultEdge> newGraph = buildGraph(newDegrees);
                graphView2.setGraph(newGraph);
                Integer[] degreesWithTwo = filterDegreeTwo(gradi);
                Graph<Integer, DefaultEdge> graphWithTwo = buildGraph(degreesWithTwo);
                graphView3.setGraph(graphWithTwo);
                logProcesso.append("Verificare manualmente se il grafo ottenuto unendo i 3-cicli e il grafo h risultante senza il 2 ha esattamente tot componenti connesse\n");
                logProcesso.append("Nuovo vettore senza gradi 2: ").append(Arrays.toString(newDegrees)).append("\n");
                logProcesso.append(newProcessLog.toString());
                logProcesso.append("\n");
            }

            if (forestaCheckBox.isChecked()) {
                if (isForest(gradi)) {
                    logProcesso.append("Esiste una foresta? SI\nMotivo: Il grafo non contiene cicli ed è completamente connesso.\n");
                } else {
                    logProcesso.append("Esiste una foresta? NO\nMotivo: Il grafo contiene cicli oppure è connesso.\n");
                }
                logProcesso.append("\n");
            }

        } catch (IllegalArgumentException e) {
            logProcesso.append("Errore: ").append(e.getMessage()).append("\n");
        }

        processTextView.append("\n\n" + logProcesso.toString());
    }


    private boolean forzaturaDiConnessione(Integer[] gradi) {
        return Collections.min(Arrays.asList(gradi))+Collections.max(Arrays.asList(gradi))>=gradi.length-1;
    }

    private String forzaturaDisconnesione(Integer[] gradi) {
        int somma = 0;
        for (int i = 0; i < gradi.length; i++) {
            somma += gradi[i];
        }

        if (somma / 2 < gradi.length - 1) {
            return "1/2 * " + somma + " < " + (gradi.length - 1);
        } else {
            return "";
        }
    }

    private boolean isForest(Integer[] degrees) {
        Graph<Integer, DefaultEdge> graph = buildGraph(degrees);
        if (containsCycle(graph)) {
            return false;
        }
        if (isConnected(graph)&&forzaturaDiConnessione(degrees)) {
            return false;
        }

        return true;
    }

    private boolean containsCycle(Graph<Integer, DefaultEdge> graph) {
        Set<Integer> visited = new HashSet<>();
        for (Integer vertex : graph.vertexSet()) {
            if (!visited.contains(vertex)) {
                if (dfsCycleCheck(vertex, -1, graph, visited)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean dfsCycleCheck(int current, int parent, Graph<Integer, DefaultEdge> graph, Set<Integer> visited) {
        visited.add(current);

        for (DefaultEdge edge : graph.edgesOf(current)) {
            int neighbor = graph.getEdgeSource(edge).equals(current) ? graph.getEdgeTarget(edge) : graph.getEdgeSource(edge);
            if (!visited.contains(neighbor)) {
                if (dfsCycleCheck(neighbor, current, graph, visited)) {
                    return true;
                }
            } else if (neighbor != parent) {
                return true;
            }
        }

        return false;
    }

    private boolean isConnected(Graph<Integer, DefaultEdge> graph) {
        // Usa DFS per verificare la connessione
        Set<Integer> visited = new HashSet<>();
        dfs(0, graph, visited);
        return visited.size() == graph.vertexSet().size();
    }


    private Integer[] removeDegreeTwo(Integer[] gradi) {
        return Arrays.stream(gradi)
                .filter(degree -> degree != 2)
                .toArray(Integer[]::new);
    }
    private Integer[] filterDegreeTwo(Integer[] degrees) {
        return Arrays.stream(degrees)
                .filter(d -> d == 2)
                .toArray(Integer[]::new);
    }

    private int countTriangles(Graph<Integer, DefaultEdge> graph) {
        int triangleCount = 0;
        for (Integer v : graph.vertexSet()) {
            for (Integer u : Graphs.neighborListOf(graph, v)) {
                for (Integer w : Graphs.neighborListOf(graph, u)) {
                    if (graph.containsEdge(w, v)) {
                        triangleCount++;
                    }
                }
            }
        }
        return triangleCount / 3; // Ogni triangolo è contato 3 volte
    }

    private Integer[] parseVector(String vectorText) {
        String[] parts = vectorText.split(",");
        Integer[] vector = new Integer[parts.length];
        for (int i = 0; parts.length > i; i++) {
            vector[i] = Integer.parseInt(parts[i].trim());
        }
        return vector;
    }

    private static void findArticulationPointsUtil(Graph<Integer, DefaultEdge> g, int u, Set<Integer> visited,
                                                   Map<Integer, Integer> discovery, Map<Integer, Integer> low, Map<Integer, Integer> parent,
                                                   Set<Integer> articulationPoints, int time) {
        int children = 0;
        visited.add(u);
        discovery.put(u, time);
        low.put(u, time);
        time++;

        for (DefaultEdge edge : g.edgesOf(u)) {
            int v = g.getEdgeTarget(edge) == u ? g.getEdgeSource(edge) : g.getEdgeTarget(edge);

            if (!visited.contains(v)) {
                children++;
                parent.put(v, u);
                findArticulationPointsUtil(g, v, visited, discovery, low, parent, articulationPoints, time);

                low.put(u, Math.min(low.get(u), low.get(v)));

                if (parent.get(u) == null && children > 1) {
                    articulationPoints.add(u);
                }

                if (parent.get(u) != null && low.get(v) >= discovery.get(u)) {
                    articulationPoints.add(u);
                }
            } else if (!Objects.equals(v, parent.get(u))) {
                low.put(u, Math.min(low.get(u), discovery.get(v)));
            }
        }
    }

    private static Set<Integer> findArticulationPoints(Graph<Integer, DefaultEdge> g) {
        Set<Integer> articulationPoints = new HashSet<>();
        Set<Integer> visited = new HashSet<>();
        Map<Integer, Integer> discovery = new HashMap<>();
        Map<Integer, Integer> low = new HashMap<>();
        Map<Integer, Integer> parent = new HashMap<>();

        int time = 0;

        for (Integer vertex : g.vertexSet()) {
            if (!visited.contains(vertex)) {
                findArticulationPointsUtil(g, vertex, visited, discovery, low, parent, articulationPoints, time);
            }
        }

        return articulationPoints.isEmpty() ? articulationPoints : articulationPoints;
    }

    public static boolean is2Connesso(Graph<Integer, DefaultEdge> g) {
        if (g.vertexSet().size() < 3) return false;

        Set<Integer> articulationPoints = findArticulationPoints(g);
        return articulationPoints.isEmpty();
    }

    private Graph<Integer, DefaultEdge> buildGraph(Integer[] degrees) {
        Graph<Integer, DefaultEdge> graph = new SimpleGraph<>(DefaultEdge.class);
        List<Node> nodes = new ArrayList<>();

        for (int i = 0; degrees.length > i; i++) {
            graph.addVertex(i);
            nodes.add(new Node(i, degrees[i]));
        }

        nodes.sort(Comparator.comparingInt(n -> -n.degree));

        while (!nodes.isEmpty()) {
            Node u = nodes.get(0);
            nodes.remove(0);

            if (u.degree > nodes.size()) {
                throw new IllegalArgumentException("Non è possibile costruire un grafo con questa sequenza di gradi.");
            }

            List<Node> toConnect = new ArrayList<>(nodes.subList(0, u.degree));

            for (Node v : toConnect) {
                graph.addEdge(u.id, v.id);
                v.degree--;
            }

            nodes.sort(Comparator.comparingInt(n -> -n.degree));

            // Rimuovi i nodi con grado zero
            nodes.removeIf(node -> node.degree == 0);
        }

        return graph;
    }

    private boolean isTree(Graph<Integer, DefaultEdge> graph) {
        return graph.edgeSet().size() == graph.vertexSet().size() - 1;
    }

    private boolean isDisconnected(Integer[] degrees) {
        int n = degrees.length;

        // Costruisci il grafo dalla sequenza di gradi
        Graph<Integer, DefaultEdge> graph = buildGraph(degrees);

        // Verifica se il grafo è connesso usando DFS
        Set<Integer> visited = new HashSet<>();
        dfs(0, graph, visited);

        // Se il numero di nodi visitati è minore del numero di vertici, il grafo è sconnesso
        return visited.size() < n;
    }

    private boolean isConnected(Integer[] degrees) {
        int n = degrees.length;

        // Costruisci il grafo dalla sequenza di gradi
        Graph<Integer, DefaultEdge> graph = new SimpleGraph<>(DefaultEdge.class);

        for (int i = 0; i < n; i++) {
            graph.addVertex(i);
        }

        Integer[] sortedDegrees = Arrays.copyOf(degrees, n);
        Arrays.sort(sortedDegrees, Collections.reverseOrder());

        for (int i = 0; i < n; i++) {
            int currentDegree = sortedDegrees[i];
            for (int j = i + 1; j < n && currentDegree > 0; j++) {
                if (sortedDegrees[j] > 0) {
                    graph.addEdge(i, j);
                    sortedDegrees[j]--;
                    currentDegree--;
                }
            }
            sortedDegrees[i] = currentDegree;
        }

        // Verifica se il grafo è connesso usando DFS
        Set<Integer> visited = new HashSet<>();
        dfs(0, graph, visited);

        // Se il numero di nodi visitati è uguale al numero di vertici, il grafo è connesso
        return visited.size() == n;
    }

    private int countConnectedComponents(Integer[] degrees) {
        int n = degrees.length;

        // Costruisci il grafo dalla sequenza di gradi
        Graph<Integer, DefaultEdge> graph = buildGraph(degrees);

        // Conta le componenti connesse
        Set<Integer> visited = new HashSet<>();
        int componentCount = 0;

        for (int i = 0; i < n; i++) {
            if (!visited.contains(i)) {
                componentCount++;
                dfs(i, graph, visited);
            }
        }

        return componentCount;
    }

    private void dfs(int v, Graph<Integer, DefaultEdge> graph, Set<Integer> visited) {
        visited.add(v);
        for (DefaultEdge edge : graph.edgesOf(v)) {
            int neighbor = graph.getEdgeSource(edge).equals(v) ? graph.getEdgeTarget(edge) : graph.getEdgeSource(edge);
            if (!visited.contains(neighbor)) {
                dfs(neighbor, graph, visited);
            }
        }
    }

    private boolean isHamiltonian(Graph<Integer, DefaultEdge> graph) {
        int V = graph.vertexSet().size();
        int[][] adjMatrix = new int[V][V];

        for (DefaultEdge edge : graph.edgeSet()) {
            int u = graph.getEdgeSource(edge);
            int v = graph.getEdgeTarget(edge);
            adjMatrix[u][v] = 1;
            adjMatrix[v][u] = 1;
        }

        HamiltonianCycle hc = new HamiltonianCycle(V);
        return hc.hamCycle(adjMatrix);
    }

    private int[][] convertGraphToAdjMatrix(Graph<Integer, DefaultEdge> graph) {
        int V = graph.vertexSet().size();
        int[][] adjMatrix = new int[V][V];

        for (DefaultEdge edge : graph.edgeSet()) {
            int u = graph.getEdgeSource(edge);
            int v = graph.getEdgeTarget(edge);
            adjMatrix[u][v] = 1;
            adjMatrix[v][u] = 1;
        }

        return adjMatrix;
    }

    private static class Node {
        int id;
        int degree;

        Node(int id, int degree) {
            this.id = id;
            this.degree = degree;
        }
    }
}
