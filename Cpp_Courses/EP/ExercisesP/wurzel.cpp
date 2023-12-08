#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;


double wurzel(double a, const int n);

int main(){
    double wert = sqrt(37.0);
    const int n = 6;
    cout << setprecision(20) << wert << endl;

    double a = 256512.698;
    cout << "Differenz: " << setprecision(17) << sqrt(a) - wurzel(a, n);
    return 0;
}

double wurzel(double a, const int n){
    double wert = (a+1.0)/2.0;
    for(int i = 0; i < n; i++){
        wert = 0.5*(wert + a/wert);
    }
    //cout << "Wert: " << wert << endl;
    return wert;
}