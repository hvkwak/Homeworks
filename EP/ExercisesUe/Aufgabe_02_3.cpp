#include <iostream>
using namespace std;

int main() {

    int i = 666;

    /* while loop
    while (i >= 1){
        if (i%2 == 1){
            cout << i << endl;
        }
        i -= 17;
    }
    */

    /* do loop Aufgabe_02_3a
    do{
        if (i%2 == 1){
            cout << i << endl;
        }
        i -= 17;
    }while(i>=1);
    */

    /* for loop: Aufgabe_02_3b */ 
    for(int k = i; k>=1; k -= 17){
        if(k%2 == 1){
            cout << k << endl;
        }
    }
    return 0;
}