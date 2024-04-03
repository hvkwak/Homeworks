
#include <iostream>
using namespace std;


int main(){

    int x1, x2, x3, a, b, c;
    cout << "Geben Sie drei Ganzzahlen ein:" << endl;
    cin >> x1 >> x2 >> x3;


    // Erweiterung:
    if(x1 <= 0 || x2 <= 0 || x3 <= 0){
        cout << "Nicht alle Variablen sind positiv" << endl;
        return 1;
    }

    // check the longest distance : Aufgabe c;
    if (x1 >= x2) {
        if (x1 >= x3){
            c = x1;
            a = x2;
            b = x3;
        }else{ // x1 < x3
            c = x3;
            b = x1;
            a = x2;
        }
    }else{ // x1 < x2
        if (x2 >= x3){
            c = x2;
            b = x1;
            a = x3;
        }else{
            c = x3;
            b = x1;
            a = x2;
        }
    }
    
    if (c >= a+b){
        cout << "It is not a triangle." << endl;
        return 1;
    }

    // check if it is rechtwinklig;
    if (a*a + b*b == c*c){
        cout << "Ja, rechtwinklig." << endl;
        return 0;
    }else{
        cout << "nein, nicht rechtwinklig" << endl;
        return 0;
    }

    return 0;
}