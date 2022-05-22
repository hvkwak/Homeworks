#include <iostream>
using namespace std;

//******************************************
// Hier die Funktionsdefinitionen ergaenzen!
//******************************************

int main() {
    char const wort1[] = "ThomasMueller";
    char const wort2[] = "LuemmelSahRot";
    int laenge1 = sizeof(wort1) / sizeof(char) - 1;
    int laenge2 = sizeof(wort2) / sizeof(char) - 1;

    if (laenge1 != laenge2) {
        std::cout << "Die Woerter \"" << wort1 << "\" und \""
                  << wort2 << "\" sind unterschiedlich lang.\n";
        return 1;
    }

    int const alphabet_groesse = 'z' - 'a' + 1;
    int anzahlen[alphabet_groesse] = {0};

    zaehleAlleHoch(wort1, laenge1, anzahlen);
    zaehleAlleRunter(wort2, laenge2, anzahlen);

    bool const istAnagramm = sindAlleNull(anzahlen, alphabet_groesse);
    if (istAnagramm) {
        cout << '\"' << wort1
             << "\" ist ein Anagramm von \""
             << wort2 << "\".\n";
        return 0;
    } else {
        cout << '\"' << wort1
             << "\" ist leider kein Anagramm von \""
             << wort2 << "\". :-((((((((((\n";
        return 1;
    }
}
