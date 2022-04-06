#include <iostream>
using namespace std;

//******************************************
// Hier die Funktionsdefinitionen ergaenzen!
//******************************************
int position(char x){
    if (97 <= x && x < 123){
        return x - 97;
    }else if(65 <= x && x < 91){
        return x-65;
    }else{
        cout << "invalid character.";
        return -1;
    }
}

void zaehleHoch(char buchstabe, int anzahlen[]){
    anzahlen[position(buchstabe)] += 1;
}

void zaehleRunter(char buchstabe, int anzahlen[]){
    anzahlen[position(buchstabe)] -= 1;
}

void zaehleAlleHoch(char const * wort1, int laenge1, int anzahlen[]){
    for(int i = 0; i < laenge1; i++){
        zaehleHoch(*(wort1+i), anzahlen);
    }
}
void zaehleAlleRunter(char const *wort2, int laenge1, int anzahlen[]){
    for(int i = 0; i < laenge1; i++){
        zaehleRunter(*(wort2+i), anzahlen);
    }
}
bool sindAlleNull(int anzahlen[], int laenge){
    for(int i = 0; i < laenge; i++){
        if(anzahlen[i] != 0){
            return false;
        }
    }
    return true;

}

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
    
    // note that wort1 and wort2 are pointers.
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
