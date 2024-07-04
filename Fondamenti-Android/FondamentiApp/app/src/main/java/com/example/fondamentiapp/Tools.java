package com.example.fondamentiapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

public class Tools extends AppCompatActivity {

    private EditText valore1, valore2, mcd1, mcd2;
    private TextView output1, output2;
    private BottomNavigationView bottomNavigationView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.toolsxml);

        bottomNavigationView = findViewById(R.id.bottom_navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(item -> {
            int itemID = item.getItemId();
            Intent intent = null;

            if (itemID == R.id.sistema3) {
                intent = new Intent(Tools.this, SistemaCongruenze.class);
            } else if (itemID == R.id.congruenzePotenza) {
                intent = new Intent(Tools.this, CongruenzaRSA.class);
            } else if (itemID == R.id.isomorfismo) {
                intent = new Intent(Tools.this, Isomorfismo.class);
            } else if (itemID == R.id.grafi) {
                intent = new Intent(Tools.this, Grafi.class);
            }

            if (intent != null) {
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                return true;
            }
            return false;

        });
        bottomNavigationView.setSelectedItemId(R.id.tools);
        valore1 = findViewById(R.id.valore1);
        valore2 = findViewById(R.id.valore2);
        mcd1 = findViewById(R.id.mcd1);
        mcd2 = findViewById(R.id.mcd2);
        output1 = findViewById(R.id.output1);
        output2 = findViewById(R.id.output2);

        Button calcolaEuclideButton = findViewById(R.id.calcola);
        Button calcolaMcdButton = findViewById(R.id.calcolaMcd);

        calcolaEuclideButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int a = Integer.parseInt(valore1.getText().toString());
                int b = Integer.parseInt(valore2.getText().toString());

                String result = modifiedMCD(b, a);
                output1.setText(result);
            }
        });

        calcolaMcdButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int a = Integer.parseInt(mcd1.getText().toString());
                int b = Integer.parseInt(mcd2.getText().toString());

                int mcd = calculateMCD(a, b);
                String result = "MCD: " + mcd + "\n";
                result += getPrimeFactors(a,b);
                output2.setText(result);
            }
        });

    }



    private String modifiedMCD(int a, int b) {
        String text = "";
        int x0 = 1, x1 = 0, y0 = 0, y1 = 1;
        int aBack = a, bBack = b;

        while (b != 0) {
            int q = a / b;
            int temp = b;
            b = a % b;
            a = temp;

            if (b != 0) {
                text += a + " = " + (a / b) + "*" + b + " + " + (a % b) + " | ";
                if (a % b != 0) {
                    text += (a % b) + " = " + a + "-" + (a / b) + "*" + b + "\n";
                }
            }

            temp = x0;
            x0 = x1;
            x1 = temp - q * x1;
            temp = y0;
            y0 = y1;
            y1 = temp - q * y1;
        }

        text += "\n";
        int finalX = x0;
        int finalY = y0;
        System.out.println(aBack + " " + bBack);
        String s = aBack > bBack ? "(" + aBack + ", " + bBack + ")" : "(" + bBack + ", " + aBack + ")";
        if (finalY > 0) {
            text += "Quindi " + s + " = " + finalX + "*" + aBack + " + " + finalY + "*" + bBack;
        } else {
            text += "Quindi " + s + " = " + finalX + "*" + aBack + finalY + "*" + bBack;
        }
        return text;
    }

    private int calculateMCD(int a, int b) {
        if (b == 0) {
            return a;
        } else {
            return calculateMCD(b, a % b);
        }
    }

    private String getPrimeFactors(int a, int b) {
        StringBuilder factorsA = new StringBuilder();
        StringBuilder factorsB = new StringBuilder();

        factorsA.append("Fattori primi di ").append(a).append(": ");
        factorsB.append("Fattori primi di ").append(b).append(": ");

        for (int i = 2; i <= a; i++) {
            while (a % i == 0) {
                factorsA.append(i).append(" ");
                a /= i;
            }
        }

        for (int i = 2; i <= b; i++) {
            while (b % i == 0) {
                factorsB.append(i).append(" ");
                b /= i;
            }
        }

        return factorsA.toString() + "\n" + factorsB.toString();
    }


}
