#include <iostream>
using namespace std;

int main() {
    // computes the approximation of pi
    unsigned int const n = 1337;
    double pi = 0.0;

    for (unsigned int k = 1; k < n; k+=1){
        if (k%2 == 0){
            pi = pi + (-1)/static_cast<float>(2*k-1);
        }else{
            pi = pi + (1)/static_cast<float>(2*k-1);
        }
    }
    pi = 4*pi;

    cout << "Approximation of Pi after" << n << "Interations: " << pi << endl;
    return 0;
}