#include <iostream>
using namespace std;

int main() {
    unsigned int const n = 18;
    int feld[n] = {56, 88, 17, 1, 30, 10, 73, 44, 23, 47, 63, 71, 8, 4, 39, 90, 82, 85};
    // ************************************
    int save;
    for (unsigned int i = 0; i < n; ++i){
        save = feld[i];
        feld[i] = feld[n-i-1];
        feld[n-i-1] = save;
    }
    // ************************************
    cout << "Die Zahlen des Arrays in umgekehrter Reihenfolge:\n";
    for (unsigned int i = 0; i < n; ++i){
        cout << feld[i] << " ";
    }
    cout << endl;
    return 0;
}