#include <iostream>
#include <math.h>
using namespace std;

int main() {
    // computes alternierende Summe
    double A[] = {3.2, 200.3, 83.22, 4.68, 564.0};
    int n = sizeof(A)/sizeof(A[0]);
    double altsum = 0;
    // Hier beliebig viele Zeilen ergaenzen

    for (int k = 1; k <= n; k +=1){
        if (k%2 == 1){
            altsum = altsum + A[k-1]/(k)*pow(-1, k-1);
        }else{
            altsum = altsum + A[k-1]/(k)*pow(-1, k-1);
        }
    }
    //
    cout << "Ergebnis: " << altsum << endl;
    return 0;
}