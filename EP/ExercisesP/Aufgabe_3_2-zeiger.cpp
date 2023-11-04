#include <iostream>
using namespace std;


int main(){

    // Augfabe a) init
    int x = 45;
    int y = -3;
    int z = 12;

    int *a = &x;
    int *b = &y;
    int *c = &z;

    // Aufgabe b) tabellarische Ausgabe
    cout << "Aufgabe b)" << endl;
    cout << "                Adresse" << "\t" << "        Inhalt" << "\t" << "        referenzierter Wert" << endl;
    cout << "Variable x"  << "\t" << &x << "\t" << x << endl;
    cout << "Variable y"  << "\t" << &y << "\t" << y << endl;
    cout << "Variable z"  << "\t" << &z << "\t" << z << endl;
    cout << endl;
    cout << "Zeiger a"  << "\t" << &a << "\t" << a << "\t" << *a << endl;
    cout << "Zeiger b"  << "\t" << &b << "\t" << b << "\t" << *b << endl;
    cout << "Zeiger c"  << "\t" << &c << "\t" << c << "\t" << *c << endl;
    cout << endl;

    // Aufgabe c) change the pointers. a -> y, b -> x
    cout << "Aufgabe c)" << endl;
    a = &y;
    b = &x;
    cout << "                Adresse" << "\t" << "        Inhalt" << "\t" << "        referenzierter Wert" << endl;
    cout << "Variable x"  << "\t" << &x << "\t" << x << endl;
    cout << "Variable y"  << "\t" << &y << "\t" << y << endl;
    cout << "Variable z"  << "\t" << &z << "\t" << z << endl;
    cout << endl;
    cout << "Zeiger a"  << "\t" << &a << "\t" << a << "\t" << *a << endl;
    cout << "Zeiger b"  << "\t" << &b << "\t" << b << "\t" << *b << endl;
    cout << "Zeiger c"  << "\t" << &c << "\t" << c << "\t" << *c << endl;
    cout << endl;

    // Aufgabe e) add 19 to variable z, indirekte Zuweisung!
    cout << "Aufgabe e)" << endl;
    *c = *c + 19;
    cout << "                Adresse" << "\t" << "        Inhalt" << "\t" << "        referenzierter Wert" << endl;
    cout << "Variable x"  << "\t" << &x << "\t" << x << endl;
    cout << "Variable y"  << "\t" << &y << "\t" << y << endl;
    cout << "Variable z"  << "\t" << &z << "\t" << z << endl;
    cout << endl;
    cout << "Zeiger a"  << "\t" << &a << "\t" << a << "\t" << *a << endl;
    cout << "Zeiger b"  << "\t" << &b << "\t" << b << "\t" << *b << endl;
    cout << "Zeiger c"  << "\t" << &c << "\t" << c << "\t" << *c << endl;
    cout << endl;    
    return 0;
}