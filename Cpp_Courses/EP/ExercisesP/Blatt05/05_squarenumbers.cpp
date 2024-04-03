#include <iostream>
#include <cmath>
using namespace std;

bool istSummeQuadratzahlen(int *a, int *b, int n){
    do {
        *b = round(sqrt(n-*a**a));
        if((*a**a + *b**b) == n){
            return true;
        }else{
            *a += 1;
        }
    } while(*a <= sqrt(n/2));
    return false;
}

int main(){
    for(int n = 1; n <=50; n++){
        // init
        int m = 1;
        int l = 0;
        int *a = &m, *b = &l;
        if(istSummeQuadratzahlen(a, b, n)){
            cout << n << endl;
        }
    }
    // cout << "istSummeQuadratzahlen(): " << istSummeQuadratzahlen(a, b, n) << endl;


    return 0;
}