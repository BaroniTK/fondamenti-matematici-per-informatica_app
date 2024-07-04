package com.example.fondamentiapp;

import android.util.Log;

import org.jgrapht.Graph;
import org.jgrapht.GraphMapping;
import org.jgrapht.alg.connectivity.ConnectivityInspector;
import org.jgrapht.alg.isomorphism.VF2GraphIsomorphismInspector;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleGraph;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class GraphicUtil {

    private static final String TAG = "GraphIsomorphism";
    private static final int MAX_ATTEMPTS = 10;  // Numero massimo di tentativi di rimappatura
    private static final ExecutorService executor = Executors.newSingleThreadExecutor();

    // Classe per il risultato dell'isomorfismo
    public static class IsomorphismResult {
        public boolean areIsomorphic;
        public List<String> failedConditions;

        public IsomorphismResult(boolean areIsomorphic, List<String> failedConditions) {
            this.areIsomorphic = areIsomorphic;
            this.failedConditions = failedConditions;
        }
    }

    // Classe per i dettagli del grafo
    public static class GraphDetails {
        public int score;
        public int connectedComponents;
        public boolean is2Connected;
        public boolean isHamiltonian;
        public Map<Integer, Integer> cycles;
        public boolean sameAdjacentDegree;
        public List<Integer> vertexDegrees; // Cambiato a List<Integer> per ordinamento

        @Override
        public String toString() {
            return "Score: " + score +
                    ", Componenti Connesse: " + connectedComponents +
                    ", 2-Connected: " + is2Connected +
                    ", Hamiltoniano: " + isHamiltonian +
                    ", Cicli: " + formatCycles(cycles) +
                    ", Grado Adiacente Uguale: " + sameAdjacentDegree +
                    ", Gradi dei Vertici: " + vertexDegrees.stream().map(String::valueOf).collect(Collectors.joining(", "));
        }

        private String formatCycles(Map<Integer, Integer> cycles) {
            return cycles.entrySet().stream()
                    .map(entry -> entry.getValue() + " cicli di lunghezza " + entry.getKey())
                    .collect(Collectors.joining(", "));
        }
    }

    public static Graph<Integer, DefaultEdge> createGraph(int vertices, String edges) {
        Graph<Integer, DefaultEdge> graph = new SimpleGraph<>(DefaultEdge.class);
        for (int i = 0; i < vertices; i++) {
            graph.addVertex(i);
        }
        String[] edgesArray = edges.split(",");
        for (String edge : edgesArray) {
            String[] verticesPair = edge.trim().split("-");
            int src = Integer.parseInt(verticesPair[0].trim());
            int dest = Integer.parseInt(verticesPair[1].trim());
            graph.addEdge(src, dest);
        }
        return graph;
    }

    public static IsomorphismResult verificaIsomorfismo(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Isomorfismo mainActivity) {
        List<String> condizioniFallite = new ArrayList<>();

        if (calcolaPunteggio(g1) != calcolaPunteggio(g2)) condizioniFallite.add("Discrepanza nel punteggio");
        if (contaComponentiConnesse(g1) != contaComponentiConnesse(g2)) condizioniFallite.add("Discrepanza nei componenti connessi");
        if (is2Connesso(g1) != is2Connesso(g2)) condizioniFallite.add("Discrepanza nella proprietà 2-connessa");
        if (isHamiltoniano(g1) != isHamiltoniano(g2)) condizioniFallite.add("Discrepanza nella proprietà Hamiltoniana");
        if (!haStessiCicli(g1, g2)) condizioniFallite.add("Discrepanza nel numero di cicli CONTROLLA MANUALMENTE, SE 1 DEI DUE E' UGUALE ALLORA OK");
        if (!haStessoGradoAdiacente(g1, g2)) condizioniFallite.add("Discrepanza nel grado dei vertici adiacenti");

        boolean tutteCondizioniPassate = condizioniFallite.isEmpty();
        executor.execute(() -> {
            String result = definisciIsomorfismoCasualeEVerificaArchi(g1, g2, mainActivity);
            System.out.println(result);
            mainActivity.runOnUiThread(() -> mainActivity.updateResult(result));
        });

        if (tutteCondizioniPassate && verificaIsomorfismoManuale(g1, g2)) {
            return new IsomorphismResult(true, Collections.emptyList());
        } else {
            if (tutteCondizioniPassate) condizioniFallite.add("Verifica manuale dell'isomorfismo fallita");
            return new IsomorphismResult(false, condizioniFallite);
        }

    }

    public static GraphDetails getGraphDetails(Graph<Integer, DefaultEdge> g) {
        GraphDetails details = new GraphDetails();
        details.score = calcolaPunteggio(g);
        details.connectedComponents = contaComponentiConnesse(g);
        details.is2Connected = is2Connesso(g);
        details.isHamiltonian = isHamiltoniano(g);
        details.cycles = contaCicli(g);
        details.sameAdjacentDegree = haStessoGradoAdiacente(g, g);
        details.vertexDegrees = getVertexDegreesList(g);

        Log.d(TAG, details.toString());

        return details;
    }

    private static Map<Integer, Integer> getVertexDegrees(Graph<Integer, DefaultEdge> g) {
        Map<Integer, Integer> vertexDegrees = new HashMap<>();
        for (Integer vertex : g.vertexSet()) {
            vertexDegrees.put(vertex, g.edgesOf(vertex).size());
        }
        return vertexDegrees;
    }

    private static List<Integer> getVertexDegreesList(Graph<Integer, DefaultEdge> g) {
        List<Integer> vertexDegrees = g.vertexSet().stream()
                .map(vertex -> g.edgesOf(vertex).size())
                .sorted()
                .collect(Collectors.toList());
        return vertexDegrees;
    }

    private static int calcolaPunteggio(Graph<Integer, DefaultEdge> g) {
        int punteggio = 0;
        for (int v : g.vertexSet()) {
            punteggio += g.edgesOf(v).size();
        }
        return punteggio;
    }

    private static int contaComponentiConnesse(Graph<Integer, DefaultEdge> g) {
        ConnectivityInspector<Integer, DefaultEdge> ispettore = new ConnectivityInspector<>(g);
        return ispettore.connectedSets().size();
    }

    public static boolean is2Connesso(Graph<Integer, DefaultEdge> g) {
        if (g.vertexSet().size() < 3) return false;

        Set<Integer> articulationPoints = findArticulationPoints(g);
        return articulationPoints.isEmpty();
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

    private static boolean isHamiltoniano(Graph<Integer, DefaultEdge> g) {
        int[][] matriceAdiacenza = creaMatriceAdiacenza(g);
        HamiltonianCycle hc = new HamiltonianCycle(matriceAdiacenza.length);
        return hc.hamCycle(matriceAdiacenza);
    }

    private static int[][] creaMatriceAdiacenza(Graph<Integer, DefaultEdge> g) {
        int n = g.vertexSet().size();
        int[][] matrice = new int[n][n];
        Map<Integer, Integer> vertexIndexMapping = new HashMap<>();
        int index = 0;

        // Create a mapping from vertex to index
        for (Integer vertex : g.vertexSet()) {
            vertexIndexMapping.put(vertex, index++);
        }

        // Fill the adjacency matrix
        for (DefaultEdge edge : g.edgeSet()) {
            int sorgente = vertexIndexMapping.get(g.getEdgeSource(edge));
            int destinazione = vertexIndexMapping.get(g.getEdgeTarget(edge));
            matrice[sorgente][destinazione] = 1;
            matrice[destinazione][sorgente] = 1;
        }

        return matrice;
    }

    private static Map<Integer, Integer> contaCicli(Graph<Integer, DefaultEdge> g) {
        Map<Integer, Integer> conteggioCicli = new HashMap<>();
        for (int i = 3; i <= 4; i++) { // Consideriamo cicli di lunghezza 3 e 4
            conteggioCicli.put(i, contaNCicli(g, i));
        }
        return conteggioCicli;
    }

    public static int contaNCicli(Graph<Integer, DefaultEdge> g, int n) {
        Set<List<Integer>> cicliUnici = new HashSet<>();
        for (Integer v : g.vertexSet()) {
            boolean[] visited = new boolean[Collections.max(g.vertexSet()) + 1];
            List<Integer> path = new ArrayList<>();
            path.add(v);
            dfsContaCicli(g, v, v, n, 0, visited, path, cicliUnici);
        }
        return cicliUnici.size();
    }

    private static void dfsContaCicli(Graph<Integer, DefaultEdge> g, int start, int current, int n, int depth,
                                      boolean[] visited, List<Integer> path, Set<List<Integer>> cicliUnici) {
        if (depth == n) {
            if (current == start) {
                List<Integer> ciclo = new ArrayList<>(path);
                Collections.sort(ciclo);
                if (!cicliUnici.contains(ciclo)) {
                    cicliUnici.add(ciclo);
                }
            }
            return;
        }
        visited[current] = true;
        for (DefaultEdge edge : g.edgesOf(current)) {
            int vicino = g.getEdgeTarget(edge) == current ? g.getEdgeSource(edge) : g.getEdgeTarget(edge);
            if (!visited[vicino] || (depth == n - 1 && vicino == start)) {
                path.add(vicino);
                dfsContaCicli(g, start, vicino, n, depth + 1, visited, path, cicliUnici);
                path.remove(path.size() - 1);
            }
        }
        visited[current] = false;
    }

    private static boolean haStessiCicli(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2) {
        return contaCicli(g1).equals(contaCicli(g2));
    }

    private static boolean haStessoGradoAdiacente(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2) {
        Map<Integer, Integer> vertexDegreesG1 = getVertexDegrees(g1);
        Map<Integer, Integer> vertexDegreesG2 = getVertexDegrees(g2);

        if (!vertexDegreesG1.values().containsAll(vertexDegreesG2.values()) || !vertexDegreesG2.values().containsAll(vertexDegreesG1.values())) {
            return false;
        }

        // Verifica che il vertice con grado massimo abbia gradi adiacenti uguali
        int maxDegreeVertexG1 = Collections.max(vertexDegreesG1.entrySet(), Map.Entry.comparingByValue()).getKey();
        int maxDegreeVertexG2 = Collections.max(vertexDegreesG2.entrySet(), Map.Entry.comparingByValue()).getKey();

        List<Integer> gradiAdiacentiG1 = g1.edgesOf(maxDegreeVertexG1).stream()
                .map(edge -> g1.edgesOf(g1.getEdgeTarget(edge) == maxDegreeVertexG1 ? g1.getEdgeSource(edge) : g1.getEdgeTarget(edge)).size())
                .sorted()
                .collect(Collectors.toList());

        List<Integer> gradiAdiacentiG2 = g2.edgesOf(maxDegreeVertexG2).stream()
                .map(edge -> g2.edgesOf(g2.getEdgeTarget(edge) == maxDegreeVertexG2 ? g2.getEdgeSource(edge) : g2.getEdgeTarget(edge)).size())
                .sorted()
                .collect(Collectors.toList());

        if (!gradiAdiacentiG1.equals(gradiAdiacentiG2)) {
            return false;
        }

        return true;
    }

    private static boolean verificaIsomorfismoManuale(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2) {
        VF2GraphIsomorphismInspector<Integer, DefaultEdge> ispettore = new VF2GraphIsomorphismInspector<>(g1, g2);
        return ispettore.isomorphismExists();
    }

    public static String definisciEVerificaIsomorfismo(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Isomorfismo mainActivity) {
        for (int attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
            // Primo controllo: se i gradi sono unici
            if (haGradiUnici(g1) && haGradiUnici(g2)) {
                String result = definisciIsomorfismoBasatoSuGradiEVerificaArchi(g1, g2, mainActivity);
                if (result.startsWith("Mappatura")) {
                    mainActivity.runOnUiThread(() -> mainActivity.updateResult(result));
                    return result;
                }
            } else {
                // Se i gradi non sono unici, utilizza l'associazione geometrica
                String result = definisciIsomorfismoGeometricoEVerificaArchi(g1, g2, mainActivity);
                if (result.startsWith("Mappatura")) {
                    mainActivity.runOnUiThread(() -> mainActivity.updateResult(result));
                    return result;
                }
            }
        }

        // Se non abbiamo trovato una mappatura valida, esegui la mappatura casuale
        executor.execute(() -> {
            String result = definisciIsomorfismoCasualeEVerificaArchi(g1, g2, mainActivity);
            mainActivity.runOnUiThread(() -> mainActivity.updateResult(result));
        });

        return "Tentativi esauriti, esecuzione della mappatura casuale...";
    }

    private static boolean haGradiUnici(Graph<Integer, DefaultEdge> g) {
        Map<Integer, Integer> vertexDegrees = getVertexDegrees(g);
        Set<Integer> gradiUnici = new HashSet<>(vertexDegrees.values());
        return gradiUnici.size() == vertexDegrees.size();
    }

    private static String definisciIsomorfismoBasatoSuGradiEVerificaArchi(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Isomorfismo mainActivity) {
        Map<Integer, Integer> vertexDegreesG1 = getVertexDegrees(g1);
        Map<Integer, Integer> vertexDegreesG2 = getVertexDegrees(g2);

        // Ordina i vertici per grado
        List<Map.Entry<Integer, Integer>> sortedG1 = vertexDegreesG1.entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .collect(Collectors.toList());
        List<Map.Entry<Integer, Integer>> sortedG2 = vertexDegreesG2.entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .collect(Collectors.toList());

        // Crea la mappatura
        Map<Integer, Integer> vertexMapping = new HashMap<>();
        for (int i = 0; i < sortedG1.size(); i++) {
            vertexMapping.put(sortedG1.get(i).getKey(), sortedG2.get(i).getKey());
        }

        // Verifica la presenza degli archi mappati in g2 e costruisce la mappatura degli archi
        StringBuilder edgeMapping = new StringBuilder("Mappatura degli archi:\n");
        if (!verificaArchiMappatiEStampa(g1, g2, vertexMapping, edgeMapping)) {
            return "Arco mancante in g2 con la mappatura basata sui gradi.";
        }

        String result = "Mappatura basata su gradi e verifica degli archi:\n" + vertexMapping + "\n" + edgeMapping + "\nTutti gli archi di g1 mappati sono presenti in g2.";
        mainActivity.isomorphismInfo = result;
        return result;
    }

    private static String definisciIsomorfismoGeometricoEVerificaArchi(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Isomorfismo mainActivity) {
        VF2GraphIsomorphismInspector<Integer, DefaultEdge> ispettore = new VF2GraphIsomorphismInspector<>(g1, g2);

        if (ispettore.isomorphismExists()) {
            Iterator<GraphMapping<Integer, DefaultEdge>> mappings = ispettore.getMappings();
            if (mappings.hasNext()) {
                GraphMapping<Integer, DefaultEdge> mapping = mappings.next();
                Map<Integer, Integer> vertexMapping = new HashMap<>();
                StringBuilder result = new StringBuilder("Mappatura geometrica:\n");

                for (Integer vertice : g1.vertexSet()) {
                    Integer verticeCorrispondente = mapping.getVertexCorrespondence(vertice, false);
                    vertexMapping.put(vertice, verticeCorrispondente);
                    result.append(vertice).append(" -> ").append(verticeCorrispondente).append("\n");
                }

                // Verifica la presenza degli archi mappati in g2 e costruisce la mappatura degli archi
                StringBuilder edgeMapping = new StringBuilder("Mappatura degli archi:\n");
                if (!verificaArchiMappatiEStampa(g1, g2, vertexMapping, edgeMapping)) {
                    return "Arco mancante in g2 con la mappatura geometrica.";
                }

                String finalResult = result.toString() + edgeMapping + "\nTutti gli archi di g1 mappati sono presenti in g2.";
                return finalResult;
            }
        }
        return "Nessun isomorfismo geometrico trovato";
    }

    private static String definisciIsomorfismoCasualeEVerificaArchi(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Isomorfismo mainActivity) {
        Random random = new Random();
        List<Integer> verticesG1 = new ArrayList<>(g1.vertexSet());
        List<Integer> verticesG2 = new ArrayList<>(g2.vertexSet());

        while (true) {
            Collections.shuffle(verticesG2, random);
            Map<Integer, Integer> mapping = new HashMap<>();
            for (int i = 0; i < verticesG1.size(); i++) {
                mapping.put(verticesG1.get(i), verticesG2.get(i));
            }

            // Verifica la presenza degli archi mappati in g2 e costruisce la mappatura degli archi
            StringBuilder edgeMapping = new StringBuilder();
            if (verificaArchiMappatiEStampa(g1, g2, mapping, edgeMapping)) {
                String result = "Mappatura casuale e verifica degli archi:\n" + mapping + "\n" + edgeMapping + "\nTutti gli archi di g1 mappati sono presenti in g2.";

                // Memorizza le informazioni di isomorfismo
                mainActivity.isomorphismInfo = "Informazioni sulla Mappatura: **Testo da scrivere**\n" +
                        "Definiamo la seguente bigezione f: V(G1) -> V(G2): \n" +
                        "V(G1) -> V(G2) \n" + mapping + "\n" +
                        "Si osservi che f è effettivamente una bigezione in quanto nella seconda colonna compaiono tutti i vertici di G2 senza ripetizioni. \n" +
                        "Vediamo se f è anche un morfismo. \n" + edgeMapping + "\n" +
                        "Poiché f(E(G1)) ⊆ E(G2), f è un morfismo. D'altra parte, nella colonna di destra compaiono tutti i lati di G2. Dunque f è un isomorfismo tra G1 e G2, quindi G≈G2 \n" +
                        "(cambia il numero del grafo G in base alle esigenze)";

                // Restituisce il risultato
                return result;
            }
        }
    }

    private static boolean verificaArchiMappatiEStampa(Graph<Integer, DefaultEdge> g1, Graph<Integer, DefaultEdge> g2, Map<Integer, Integer> mapping, StringBuilder edgeMapping) {
        for (DefaultEdge edge : g1.edgeSet()) {
            int source = g1.getEdgeSource(edge);
            int target = g1.getEdgeTarget(edge);
            int mappedSource = mapping.get(source);
            int mappedTarget = mapping.get(target);

            if (!g2.containsEdge(mappedSource, mappedTarget)) {
                return false;
            } else {
                edgeMapping.append(source).append("-").append(target).append(" -> ").append(mappedSource).append("-").append(mappedTarget).append("\n");
            }
        }
        return true;
    }
}
