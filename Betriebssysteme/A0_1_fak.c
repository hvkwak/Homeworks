#include <stdio.h>

// computes the factorial of n.
int global_initialisierte = 0;
int global_uninitialisierte;

int fak(int n){
    // Stack
    // Addresse einer lokalen Variablen in der rekursiven Funktion immer kleiner, da der Vorherige im Stack hingelegt werden und
    // ein Neuer kommt auf die Stack hin.
    printf("Adresse von n ist %p\n", &n);
    if(n == 0 || n == 1){
        return 1;
    }else{
        return n*fak(n-1);
    }
}

int main(void){
    int n = 5; // Stack
    int m;
    m = fak(n);
    printf("Fakultaet von %d lautet: %d\n",n, m);

    // Voelling andere Adresse
    // Uninitiliaisierte Daten im BSS
    // Vorinitialisierte Daten im Datensegment
    printf("Adresse von global_initialisierte ist %p\n", &global_initialisierte);
    printf("Adresse von global_uninitialisierte ist %p\n", &global_uninitialisierte);
    return 0;
}