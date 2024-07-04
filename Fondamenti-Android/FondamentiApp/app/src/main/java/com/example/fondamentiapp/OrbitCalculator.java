package com.example.fondamentiapp;

import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

public class OrbitCalculator {

    public static List<Long> calculateOrbit(long base, long modulus,TextView orbita) {
        List<Long> orbit = new ArrayList<>();
        long result = base;
        String out="";

        for (int exponent = 1; ; exponent++) {
            orbit.add(result);
            result = (result * base) % modulus;
            out+="modulo di " + base + "^" + (exponent+1) + " mod " + modulus + " è " + result+"\n";
            if (result == base) {
                break;
            }
        }
        orbita.setText(out);
        return orbit;
    }

    public static long calculatePower(long base, long exponent, long modulus, TextView orbita) {
        List<Long> orbit = calculateOrbit(base, modulus,orbita);
        int orbitSize = orbit.size();
        long reducedExponent = exponent % orbitSize;

        long result = orbit.get((int) (reducedExponent - 1));
        if (result < 0) {
            result += modulus;
        }

        return result;
    }
}
