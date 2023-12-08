#include <iostream>
using namespace std;


int main(){
    int x, y, z;
    cout << "Enter (int)value of x" << endl;
    cin >> x;
    cout << "Enter (int)value of y" << endl;
    cin >> y;
    cout << "Enter (int)value of z" << endl;
    cin >> z;
    
    int *a = &x;
    int *b = &y;
    int *c = &z;

    // aufgabe b)
    // x: sum of the three variables
    // y: product of three variables
    x = *a + *b + *c;
    y = *a**b**c;
    cout << "sum of three variables:" << x << endl;
    cout << "product of three variables:" << y << endl;

    return 0;
}