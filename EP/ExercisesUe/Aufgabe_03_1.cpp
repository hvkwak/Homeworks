#include <iostream>
using namespace std;

int main() {

    int *x, y, z[1];
    y = 2;
    x = &y;
    z[0] = ++*x; // this will be 3 in z[0] and *x
    
    cout << z[*x-3] << endl; // this calls z[0]
    return 0;
}