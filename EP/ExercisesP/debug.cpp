#include <iostream>
using namespace std;

int main() {
    int eineZahl;
    int andereZahl = 8;
    char* text1 = new char[20];
    char text2[20];
    char a = 'q';
    char b = '&';
    

    cout << "Zahlenvergleich" << endl;

    eineZahl = 9;

    if(eineZahl == andereZahl) {
        cout << "Beide Werte sind gleich gross: " << eineZahl << endl;
    }
    else if (andereZahl > eineZahl) {
        cout << "Der kleinere Wert ist eine Zahl: " << eineZahl << endl;
    }
    else {
        cout << "Der kleinere Wert ist andere Zahl: " << andereZahl << endl;
    }

    delete[] text1;

    return 0;
}
