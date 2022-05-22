#include <iostream>
using namespace std;

void halbiere(int *n){
    *n = static_cast<float>(*n)/2;
}

int main() {

    unsigned int const n = 6;
    int zahl[n] = { 9, 34, -8, 42, 44221, 1 };
    cout << "Zahlen vor der Halbierung" << endl;
    for (unsigned int i = 0; i < n; ++i) {
        cout << (i + 1) << ". Zahl: " << zahl[i] << endl;
    }
    for (unsigned int i = 0; i < n; ++i){
        halbiere(&zahl[i]);
    }

    cout << "Zahlen nach Halbierung" << endl;
    for (unsigned int i = 0; i < n; ++i) {
        cout << (i + 1) << ". Zahl: " << zahl[i] << endl;
    }
    return 0;
}