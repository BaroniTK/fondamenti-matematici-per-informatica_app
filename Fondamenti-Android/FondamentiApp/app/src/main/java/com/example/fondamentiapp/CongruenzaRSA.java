package com.example.fondamentiapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

public class CongruenzaRSA extends AppCompatActivity {

    private EditText esponente, valore, modulo;
    private TextView orbita;
    private BottomNavigationView bottomNavigationView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.congruenzarsa);

        esponente = findViewById(R.id.esponente);
        valore = findViewById(R.id.valore);
        modulo = findViewById(R.id.modulo);
        orbita=findViewById(R.id.orbita);

        TextView minResultTextView = findViewById(R.id.minResultTextView);
        TextView maxResultTextView = findViewById(R.id.maxResultTextView);

        Button inviaButton = findViewById(R.id.invia);

        bottomNavigationView = findViewById(R.id.bottom_navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(item -> {
            int itemID = item.getItemId();
            Intent intent = null;

            if (itemID == R.id.sistema3) {
                intent = new Intent(CongruenzaRSA.this, SistemaCongruenze.class);
            } else if (itemID == R.id.tools) {
                intent = new Intent(CongruenzaRSA.this, Tools.class);
            } else if (itemID == R.id.isomorfismo) {
                intent = new Intent(CongruenzaRSA.this, Isomorfismo.class);
            } else if (itemID == R.id.grafi) {
                intent = new Intent(CongruenzaRSA.this, Grafi.class);
            }

            if (intent != null) {
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                return true;
            }
            return false;
        });

        bottomNavigationView.setSelectedItemId(R.id.congruenzePotenza);
        inviaButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                long modulus = Long.parseLong(modulo.getText().toString());
                long residue = Long.parseLong(valore.getText().toString());
                long exp = Long.parseLong(esponente.getText().toString());

                long result = OrbitCalculator.calculatePower(residue, exp, modulus,orbita);

                if (result < 0) {
                    result += modulus;
                }

                System.out.println(residue + "^" + exp + " mod " + modulus + " = " + result);

                Long minResult = minPositiveSolution(modulus, residue, exp);
                Long maxResult = maxNegativeSolution(modulus, residue, exp);

                if (minResult != null) {
                    minResultTextView.setText("Min x ≡ " + minResult + " mod " + modulus);
                } else {
                    minResultTextView.setText("Non esiste soluzione positiva");
                }

                if (maxResult != null) {
                    maxResultTextView.setText("Max x ≡ " + maxResult + " mod " + modulus);
                } else {
                    maxResultTextView.setText("Non esiste soluzione negativa");
                }
            }
        });
    }

    public long modPow(long base, long exp, long mod) {
        long result = 1;
        base = base % mod;
        while (exp > 0) {
            if (exp % 2 == 1) {
                result = (result * base) % mod;
            }
            exp = exp / 2;
            base = (base * base) % mod;
        }
        return result;
    }

    public Long minPositiveSolution(long modulus, long residue, long exp) {
        for (long x = 1; x < modulus; x++) {
            if (modPow(x, exp, modulus) == residue) {
                return x;
            }
        }
        return null;
    }

    public Long maxNegativeSolution(long modulus, long residue, long exp) {
        Long minPositive = minPositiveSolution(modulus, residue, exp);
        if (minPositive != null) {
            return minPositive - modulus;
        }
        return null;
    }
}
