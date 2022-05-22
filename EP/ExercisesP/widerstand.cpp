#include <iostream>
using namespace std;

int main(){

    // Dieses Programm berechnet den elektrischen Widerstand
    double strom = 5.0;
    double spannung = 230.0;
    cout << "Berechneter Widerstand: " ;
    double widerstand = spannung / strom;
    cout << widerstand << endl;
    
    return 0; // fertig
}
