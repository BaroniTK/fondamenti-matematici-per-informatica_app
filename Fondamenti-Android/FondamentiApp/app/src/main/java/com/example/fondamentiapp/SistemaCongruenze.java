package com.example.fondamentiapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;

import java.util.Arrays;
import java.util.Objects;

public class SistemaCongruenze extends AppCompatActivity {

    private TextView passaggiText, risultato, passaggiText2;
    private ScrollView scrollView;
    private String assioma1, assioma2, out1, out2;

    private BottomNavigationView bottomNavigationView;
    private int soluzione = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fondamenti);

        final EditText a1 = findViewById(R.id.a1);
        final EditText b1 = findViewById(R.id.b1);
        final EditText a2 = findViewById(R.id.a2);
        final EditText b2 = findViewById(R.id.b2);
        this.passaggiText = findViewById(R.id.passaggiText);
        Button calculateButton = findViewById(R.id.calculateButton);
        risultato = findViewById(R.id.resultTextView);
        scrollView = findViewById(R.id.scrollView);
        passaggiText2 = findViewById(R.id.passaggiText2);

        bottomNavigationView = findViewById(R.id.bottom_navigation);
        bottomNavigationView.setOnNavigationItemSelectedListener(item->{
            int itemID = item.getItemId();
            Intent intent = null;

            if (itemID == R.id.congruenzePotenza) {
                intent = new Intent(SistemaCongruenze.this, CongruenzaRSA.class);
            } else if (itemID == R.id.tools) {
                intent = new Intent(SistemaCongruenze.this, Tools.class);
            } else if (itemID == R.id.isomorfismo) {
                intent = new Intent(SistemaCongruenze.this, Isomorfismo.class);
            } else if (itemID == R.id.grafi) {
                intent = new Intent(SistemaCongruenze.this, Grafi.class);
            }

            if (intent != null) {
                startActivity(intent);
                overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
                finish();
                return true;
            }
            return false;
                });
                bottomNavigationView.setSelectedItemId(R.id.sistema3);



        calculateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int aVal1 = Integer.parseInt(a1.getText().toString());
                int bVal1 = Integer.parseInt(b1.getText().toString());
                int aVal2 = Integer.parseInt(a2.getText().toString());
                int bVal2 = Integer.parseInt(b2.getText().toString());
                System.out.println(aVal2);
                int result = teoremaNihao(aVal1, bVal1, aVal2, bVal2);
                risoluzione(aVal1, aVal2, bVal1, bVal2);
                risultato.setText("Risultato: x ≡ " + result + "mcm: " + mcm(bVal1, bVal2));
            }
        });


    }




    private int mcm(int a, int b){
        return (a*b)/mcd(a,b);
    }

    private int mcd(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    private int teoremaNihao(int a1, int b1, int a2, int b2) {
        for (int i = 0; i < b1 * b2; i++) {
            if (i % b1 == a1 && i % b2 == a2) {
                return i;
            }
        }
        return -1;
    }

    private void risoluzione(int a1, int a2, int b1, int b2) {
        String text2="";
        int resto=0;
        //COMPATIBILITA
        String text = "Sia s l'insieme delle soluzioni\n";

        text += "Passo 1: COMPATIBILITA':\n";
        text += "Calcolo mcd tra " + b1 + " e " + b2 + "\n";

        int mcd = mcd(b1, b2);
        int diff_a = Math.abs(a1 - a2);
        int divisione = diff_a % mcd;
        int diff2=a2-a1;
        System.out.println("divisione: " + divisione);
        if (divisione != 0) {
            text += "Il teorema cinese del resto non assicura che s≠Ø, il sistema è incompatibile.";
            passaggiText.setText(text);
            return;
        }
        resto=diff_a/mcd;
        int resto2=diff2/mcd;
        text += "Poichè mcd(" + b1 + ", " + b2 + ") = " + mcd + ", " + mcd + " divide " + diff_a + ", il sistema è compatibile\n";
        text += "Il teorema cinese del resto assicura che s≠Ø, ovvero il sistema è compatibile\n";
        assioma1=a1 + " - (" + a2 + ") = " + diff_a + " * " + (b1 > b2 ? "(" + b1 + ", " + b2 + ") (1)\n" : "(" + b2 + ", " + b1 + ")\n");
        text += "Inoltre vale: " + a1 + " - (" + a2 + ") = " + resto2 + " * " + (b1 > b2 ? "(" + b1 + ", " + b2 + ") (1)\n" : "(" + b2 + ", " + b1 + ") (1)\n");

        //SOLUZIONE C
        text += "Passo 2: CALCOLO DI UNA SOLUZIONE C: \n";
        text += "Applico l'algoritmo di euclide a " + (b1 > b2 ? "(" + b1 + ", " + b2 + ") con sostituzione 'a ritroso': \n" : "(" + b2 + ", " + b1 + ") con sostituzione 'a ritroso': \n");
        text += modifiedMCD(b2, b1);
        text+="Dalla (1) e la (2) segue che: \n";
        text+=sortStatement(resto,a2,a1,b2,b1);
        text+="Passo 3: CALCOLO DI S (Insieme delle soluzioni): \n Grazie al teorema cinese del resto, vale:\n";
        text+="["+b1+","+b2+"]="+b1+"*"+b2+"/"+mcd(b1,b2)+"="+mcm(b1,b2)+"\n Dunque: ["+soluzione+"]"+mcm(b1,b2)+"=";
        if (soluzione > 0) {
            while (soluzione - mcm(b1, b2) >= 0) {
                soluzione -= mcm(b1, b2);
            }
        } else {
            while (soluzione + mcm(b1, b2) <= 0) {
                soluzione += mcm(b1, b2);
            }
            if(soluzione<0){
                soluzione += mcm(b1, b2);
            }

        }


        text+="["+soluzione+"]"+mcm(b1,b2)+"={"+soluzione+"+"+mcm(b1,b2)+"k∈Z|k∈Z}\n\n";
        passaggiText.setText(text);
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
            assioma2 = s + " = " + finalX + "*" + aBack + " + " + finalY + "*" + bBack;
            text += "Quindi " + s + " = " + finalX + "*" + aBack + " + " + finalY + "*" + bBack + "(2)\n";
        } else {
            assioma2 = s + " = " + finalX + "*" + aBack + finalY + "*" + bBack;
            text += "Quindi " + s + " = " + finalX + "*" + aBack + finalY + "*" + bBack + "(2)\n";
        }
        return text;
    }





    private String sortStatement(int resto, int a1, int a2, int b1, int b2) {
        String out = "";

        String[] splitAssioma1 = assioma1.split("=");
        String[] splitAssioma2 = assioma2.split("=");

        String[] xy = extractXY(splitAssioma2[1]);
        System.out.println(Arrays.toString(xy));
        int newX = resto * Integer.parseInt(xy[0]);
        int newY = resto * Integer.parseInt(xy[1]);

        out += splitAssioma1[0] + " = " + resto + splitAssioma2[0] + " = " + resto + " (" + splitAssioma2[1] + ")\n";

        String a1Adjusted = a1 + (newX > 0 ? " - " : " + ") + Math.abs(newX) + " * " + b1;
        String a2Adjusted = a2 + (newY > 0 ? " - " : " + ") + Math.abs(newY) + " * " + b2;
        System.out.println(a2Adjusted);
        out += splitAssioma1[0] + " = " + (newX > 0 ? " + " : " - ") + Math.abs(newX)+ "*" + b1+(newY > 0 ? " + " : " - ") + Math.abs(newY)+ "*" + b2+"\n";
        String[] check=scambia(a2Adjusted,a1Adjusted);
        out += out1 + " = " + out2 + "\n";
        if (Objects.equals(check[0], check[1])) {
            out += check[0] + "\t|\t" + check[1] + "\n";
            soluzione = Integer.parseInt(check[0])  ;
            out += "Segue che c := " + check[0] + " è una soluzione del sistema, ovvero c ∈ S\n";
        }
        return out;
    }
    private int[] checkEquality(String eq1, String eq2) {
        int[] out=new int[2];
        Expression e1 = new ExpressionBuilder(eq1).build();
        Expression e2 = new ExpressionBuilder(eq2).build();

        out[0] = (int)e1.evaluate();
        out[1]= (int)e2.evaluate();
        return out;
    }


    private String[] extractXY(String equation) {
        String[] xy = new String[2];
        int index = 0;

        String cleanEquation = equation.replaceAll("\\(", "").replaceAll("\\)", "").replaceAll(" ", "");
        System.out.println(cleanEquation);
        String[] parts=null;
        if(cleanEquation.contains("+")){
            parts= cleanEquation.split("\\+");
        }else{
            parts= cleanEquation.split("-");
            parts[1]=  "-"+parts[1];
        }

        System.out.println("PArti"+Arrays.toString(parts));

        for (String part : parts) {
            if (part.contains("*")) {
                String[] terms = part.split("\\*");
                if (terms.length == 2) {
                    String coefficient = terms[0];
                    String value = terms[1];
                    System.out.println("coefficient: " + coefficient);
                    if (coefficient.startsWith("-")) {
                        coefficient = "-" + coefficient.substring(1);
                    }
                    xy[index] = coefficient;
                    index++;
                }
            }
        }

        return xy;
    }

    public static int opposto(int numero) {
        return -numero;
    }

    private String[] scambia(String a1, String a2) {
        String[] splita1 = a1.split(" ");
        String[] splita2 = a2.split(" ");
        int temp1 = 0, temp2 = 0;

        for (int i = 0; i < splita1.length; i++) {
            splita1[i] = splita1[i].trim();
            splita2[i] = splita2[i].trim();
        }

        String newA1 = String.join(" ", splita1);
        String newA2 = String.join(" ", splita2);

        do {
            splita1[1] = cambiaSegno(splita1[1]);
            newA1 = String.join(" ", splita1);

            int[] checkA1 = checkEquality(newA1, a2);
            temp1 = checkA1[0];
            temp2 = checkA1[1];

            if (temp1 != temp2) {
                splita2[1] = cambiaSegno(splita2[1]);
                newA2 = String.join(" ", splita2);
                int[] checkA2 = checkEquality(a1, newA2);
                temp1 = checkA2[0];
                temp2 = checkA2[1];
            }
        } while (temp1 != temp2);
        out1=newA1;
        out2=newA2;
        String[] out = {String.valueOf(temp1), String.valueOf(temp2)};
        return out;
    }
    private String cambiaSegno(String operatore) {
        return operatore.equals("+") ? "-" : "+";
    }


}