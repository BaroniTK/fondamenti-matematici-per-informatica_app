package com.example.fondamentiapp;

public class HamiltonianCycle {
    private int V;
    private int path[];

    public HamiltonianCycle(int V) {
        this.V = V;
        path = new int[V];
    }

    private boolean isSafe(int v, int graph[][], int path[], int pos) {
        if (graph[path[pos - 1]][v] == 0)
            return false;

        for (int i = 0; i < pos; i++)
            if (path[i] == v)
                return false;

        return true;
    }

    private boolean hamCycleUtil(int graph[][], int path[], int pos) {
        if (pos == V) {
            return graph[path[pos - 1]][path[0]] == 1;
        }

        for (int v = 1; v < V; v++) {
            if (isSafe(v, graph, path, pos)) {
                path[pos] = v;

                if (hamCycleUtil(graph, path, pos + 1))
                    return true;

                path[pos] = -1;
            }
        }

        return false;
    }

    public boolean hamCycle(int graph[][]) {
        for (int i = 0; i < V; i++)
            path[i] = -1;

        path[0] = 0;
        return hamCycleUtil(graph, path, 1);
    }

    public int[] getHamiltonianCycle() {
        return path;
    }
}
