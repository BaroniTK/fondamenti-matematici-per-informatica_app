package com.example.fondamentiapp;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import org.jgrapht.Graph;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleGraph;

import java.util.ArrayList;
import java.util.List;

public class Isomorfismo extends AppCompatActivity {

    private static final String TAG = "GraphIsomorphism";


    private LinearLayout contenitoreInput; // Contenitore per i campi di input
    private TextView testoRisultato, testoCondizioniFallite, testoIsomorfismo, testoDettagliCondizioni; // TextView per mostrare i risultati
    private List<EditText> inputGrafi = new ArrayList<>(); // Lista di campi di input per i grafi
    private int numeroDiGrafi; // Numero di grafi da verificare
    protected String isomorphismInfo; // Stringa per memorizzare le informazioni sull'isomorfismo

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.isomorfismo);

        contenitoreInput = findViewById(R.id.inputContainer);
        testoRisultato = findViewById(R.id.textViewResult);
        testoCondizioniFallite = findViewById(R.id.textViewFailedConditions);
        testoIsomorfismo = findViewById(R.id.textViewIsomorphism);
        testoDettagliCondizioni = findViewById(R.id.textViewConditionDetails);

        mostraDialogoNumeroGrafi();

        Button bottoneVerificaIsomorfismo = findViewById(R.id.buttonCheckIsomorphism);
        bottoneVerificaIsomorfismo.setOnClickListener(v -> verificaIsomorfismo());

        BottomNavigationView bottomNavigationView = findViewById(R.id.bottom_navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(item -> {
            int itemID = item.getItemId();
            Intent intent = null;

            if (itemID == R.id.congruenzePotenza) {
                intent = new Intent(Isomorfismo.this, CongruenzaRSA.class);
            } else if (itemID == R.id.tools) {
                intent = new Intent(Isomorfismo.this, Tools.class);
            } else if (itemID == R.id.sistema3) {
                intent = new Intent(Isomorfismo.this, SistemaCongruenze.class);
            } else if (itemID == R.id.grafi) {
                intent = new Intent(Isomorfismo.this, Grafi.class);
            }

            if (intent != null) {
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                return true;
            }
            return false;
        });
        bottomNavigationView.setSelectedItemId(R.id.isomorfismo);
    }


    // Mostra un dialogo per inserire il numero di grafi da verificare
    private void mostraDialogoNumeroGrafi() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Inserisci il numero di grafi");

        final EditText input = new EditText(this);
        input.setInputType(InputType.TYPE_CLASS_NUMBER);
        builder.setView(input);

        builder.setPositiveButton("OK", (dialog, which) -> {
            numeroDiGrafi = Integer.parseInt(input.getText().toString());
            aggiungiCampiInputGrafi(numeroDiGrafi);
        });
        builder.setNegativeButton("Annulla", (dialog, which) -> dialog.cancel());

        builder.show();
    }

    // Aggiunge i campi di input per i grafi
    private void aggiungiCampiInputGrafi(int count) {
        for (int i = 1; i <= count; i++) {
            EditText inputGrafo = new EditText(this);
            inputGrafo.setHint("Input per il Grafo " + i + " (formato: archi)");
            contenitoreInput.addView(inputGrafo);
            inputGrafi.add(inputGrafo);
        }
    }

    // Verifica l'isomorfismo dei grafi inseriti
    private void verificaIsomorfismo() {
        List<Graph<Integer, DefaultEdge>> grafi = new ArrayList<>();

        for (int i = 0; i < numeroDiGrafi; i++) {
            Graph<Integer, DefaultEdge> grafo = parseInputGrafo(inputGrafi.get(i).getText().toString());
            if (grafo == null) {
                String msg = "Input non valido per il grafo " + (i + 1);
                testoRisultato.setText(msg);
                Log.d(TAG, msg);
                return;
            }
            grafi.add(grafo);
            Log.d(TAG, "Grafo creato: " + grafo.toString());
        }

        if (grafi.size() > 1) {
            boolean tuttiIsomorfi = true;
            StringBuilder tuttiRisultati = new StringBuilder();
            StringBuilder dettagliCondizioni = new StringBuilder();

            for (int i = 0; i < grafi.size(); i++) {
                for (int j = i + 1; j < grafi.size(); j++) {
                    GraphicUtil.IsomorphismResult result = GraphicUtil.verificaIsomorfismo(grafi.get(i), grafi.get(j), this);
                    if (!result.areIsomorphic) {
                        tuttiIsomorfi = false;
                    }
                    tuttiRisultati.append("Grafo ").append(i + 1).append(" vs Grafo ").append(j + 1).append(": ")
                            .append(result.areIsomorphic ? "Isomorfo\n" : "Non Isomorfo\n");

                    if (!result.failedConditions.isEmpty()) {
                        StringBuilder testoCondizioniFallite = new StringBuilder("Condizioni non verificate per Grafo ").append(i + 1).append(" vs Grafo ").append(j + 1).append(":\n");
                        for (String condition : result.failedConditions) {
                            testoCondizioniFallite.append("- ").append(condition).append("\n");
                        }
                        tuttiRisultati.append(testoCondizioniFallite).append("\n");
                    }

                    if (result.areIsomorphic) {
                        String isomorfismo = GraphicUtil.definisciEVerificaIsomorfismo(grafi.get(i), grafi.get(j), this);
                        tuttiRisultati.append(isomorfismo).append("\n");
                    }

                    // Append condition details
                    GraphicUtil.GraphDetails detailsG1 = GraphicUtil.getGraphDetails(grafi.get(i));
                    GraphicUtil.GraphDetails detailsG2 = GraphicUtil.getGraphDetails(grafi.get(j));
                    dettagliCondizioni.append("Dettagli del Grafo ").append(i + 1).append(":\n").append(detailsG1).append("\n");
                    dettagliCondizioni.append("Dettagli del Grafo ").append(j + 1).append(":\n").append(detailsG2).append("\n");
                }
            }

            String risultatoFinale = tuttiIsomorfi ? "Tutti i grafi sono isomorfi" : "Alcuni grafi non sono isomorfi";
            testoRisultato.setText(risultatoFinale);
            testoIsomorfismo.setText(tuttiRisultati.toString());
            testoDettagliCondizioni.setText(dettagliCondizioni.toString());

            Log.d(TAG, risultatoFinale);
            Log.d(TAG, tuttiRisultati.toString());
            Log.d(TAG, dettagliCondizioni.toString());
        } else {
            String msg = "Inserisci più di un grafo";
            testoRisultato.setText(msg);
            Log.d(TAG, msg);
        }
    }

    public void updateResult(String result) {
        runOnUiThread(() -> testoRisultato.setText(result));
    }

    // Mostra la finestra di dialogo con le informazioni
    public void showInfoDialog(String title, String message) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(title);
        builder.setMessage(message);
        builder.setPositiveButton("OK", null);
        builder.show();
    }

    public void onShowIsomorphismInfoClicked(View view) {
        if (isomorphismInfo != null) {
            showInfoDialog("Informazioni sulla Mappatura", isomorphismInfo);
        } else {
            showInfoDialog("Informazioni sulla Mappatura", "Nessuna informazione disponibile.");
        }
    }

    // Parla l'input del grafo e crea il grafo
    private Graph<Integer, DefaultEdge> parseInputGrafo(String input) {
        try {
            String archi = input.trim();

            // Crea il grafo
            Graph<Integer, DefaultEdge> grafo = new SimpleGraph<>(DefaultEdge.class);

            // Aggiunge archi e gestisce dinamicamente i vertici
            String[] arrayArchi = archi.split(",");
            for (String arco : arrayArchi) {
                arco = arco.trim();
                String[] coppiaVertici = arco.split("-");
                int etichettaSorgente = Integer.parseInt(coppiaVertici[0].trim());
                int etichettaDestinazione = Integer.parseInt(coppiaVertici[1].trim());

                grafo.addVertex(etichettaSorgente);
                grafo.addVertex(etichettaDestinazione);
                grafo.addEdge(etichettaSorgente, etichettaDestinazione);
            }

            return grafo;
        } catch (Exception e) {
            Log.e(TAG, "Errore nel parsing del grafo: " + e.getMessage());
            return null;
        }
    }
}