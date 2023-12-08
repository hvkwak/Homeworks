#include <iostream>
using namespace std;
//***************************************************************
// Ergaenzen: Definition der Funktion produkt_summe_und_differenz
//***************************************************************

void produkt_summe_und_differenz(int zahl1, int zahl2, int & produkt, int & summe, int & differenz){
    produkt = zahl1 * zahl2;
    summe = zahl1 + zahl2;
    if(zahl1 > zahl2){
        differenz = zahl1 - zahl2;
    }else{
        differenz = zahl2 - zahl1;
    }
}

int main() {
    int const zahl1 = 242, zahl2 = -9;
    int produkt, summe, differenz;
    
    produkt_summe_und_differenz(zahl1, zahl2, produkt, summe, differenz);
    
    cout << "Produkt: " << produkt << endl;
    cout << "Summe: " << summe << endl;
    cout << "Differenz: " << differenz << endl;
    return 0;
}