#include <iostream>
#include <cmath>
using namespace std;

void gibPrimfaktorenAus(int zahl, bool ist_prim[]){
    if(*ist_prim){
        cout << zahl << ": " << "prim" << endl;
    }else{
        cout << zahl << ": ";
        for(int p = 2; p <= zahl; p++){
            while(zahl % p == 0){
                zahl = zahl/p;
                if(zahl%p != 0 && p <= zahl){
                    cout << p << ", ";
                }else if(zahl%p != 0 && zahl < p){
                    cout << p << endl;
                }else{
                    cout << p << ", ";
                }
                
            } 
        }
        
    }
}

void gibPrimfaktorenAus2(int zahl, int anzahl_primzahlen, int primzahlen[]){
    
}

int main(){

    // a)
    bool *ist_prim;
    int N = 1000;
    ist_prim = new bool[N];
    int primzahlen[N];
    int anzahl = 1;
    
    for(int i = 2; i < N; i++){
        *(ist_prim+i) = 1;
    }

    // das Sieb des Eratosthenes
    for(int i = 2; i <= sqrt(N); i++){
        if(*(ist_prim+i)){
            //
            //
            for(int j = i*i ; j < N; j+=i){
                *(ist_prim+j) = 0;
            }
        }
    }
    for(int i = 2; i < N; i++){
        // hier array primzahlen befuellen
        if(*(ist_prim+i)){
            primzahlen[anzahl-1] = i;
            anzahl += 1;
        }
        //gibPrimfaktorenAus(i, ist_prim+i);
    }

    /*
    const N = 10000
    var gestrichen: array [2..N] of boolean

    // Initialisierung des Primzahlfeldes
    // Alle Zahlen im Feld sind zu Beginn nicht gestrichen
    for i = 2 to N do
        gestrichen[i] = false
    end

    // Siebe mit allen (Prim-) Zahlen i, wobei i der kleinste Primfaktor einer zusammengesetzten
    // Zahl j = i*k ist. Der kleinste Primfaktor einer zusammengesetzten Zahl j kann nicht größer
    // als die Quadratwurzel von j <= n sein.
    for i = 2 to sqrt(N) do
        if not gestrichen[i] then
            // i ist prim, gib i aus...
            print i;
            print ", ";
            // ...und streiche seine Vielfachen, beginnend mit i*i
            // (denn k*i mit k<i wurde schon als Vielfaches von k gestrichen)
            for j = i*i to N step i do
                gestrichen[j] = true
            end
        end if
    end
    // Gib die Primzahlen größer als Wurzel(n) aus - also die, die noch nicht gestrichen wurden
    for i = sqrt(N)+1 to N do
        if not gestrichen[i] then
            // i ist prim, gib i aus
            print i; ", ";
        end if
    end    
    */

    delete[] ist_prim;
    return 0;
}