#include <iostream>

int main(){

    int x = 45, y = -3, z = 12;
    int *a = &x; 
    int *b = &y; 
    int *c = &z;

    std::cout << "\t" << "    Adresse" << "\t\t" << "Inhalt" << "\t\t" << "referenzierter Wert" << std::endl;
    std::cout << "Variable x  " << a << "\t" << *a << std::endl; 
    std::cout << "Variable y  " << b << "\t" << *b << std::endl; 
    std::cout << "Variable z  " << c << "\t" << *c << std::endl;

    std::cout << "" << std::endl; 
    std::cout << "Zeiger a  " << &a << "\t" << a << "\t" << *a << std::endl; 
    std::cout << "Zeiger b  " << &b << "\t" << b << "\t" << *b << std::endl; 
    std::cout << "Zeiger c  " << &c << "\t" << c << "\t" << *c << std::endl; 

    // Tauschen Sie die Zeigerwerte so, dass anschließend a auf y und b auf x zeigt
    std::cout << "" << std::endl; 
    a = &y;
    b = &x;

    std::cout << "\t" << "    Adresse" << "\t\t" << "Inhalt" << "\t\t" << "referenzierter Wert" << std::endl;
    std::cout << "Variable x  " << a << "\t" << *a << std::endl; 
    std::cout << "Variable y  " << b << "\t" << *b << std::endl; 
    std::cout << "Variable z  " << c << "\t" << *c << std::endl;

    std::cout << "" << std::endl; 
    std::cout << "Zeiger a  " << &a << "\t" << a << "\t" << *a << std::endl; 
    std::cout << "Zeiger b  " << &b << "\t" << b << "\t" << *b << std::endl; 
    std::cout << "Zeiger c  " << &c << "\t" << c << "\t" << *c << std::endl; 


    // Erhöhen Sie den Wert der Variablen z um 19.
    *c = *c + 19;
    std::cout << "" << std::endl; 
    std::cout << "\t" << "    Adresse" << "\t\t" << "Inhalt" << "\t\t" << "referenzierter Wert" << std::endl;
    std::cout << "Variable x  " << a << "\t" << *a << std::endl; 
    std::cout << "Variable y  " << b << "\t" << *b << std::endl; 
    std::cout << "Variable z  " << c << "\t" << *c << std::endl;

    std::cout << "" << std::endl; 
    std::cout << "Zeiger a  " << &a << "\t" << a << "\t" << *a << std::endl; 
    std::cout << "Zeiger b  " << &b << "\t" << b << "\t" << *b << std::endl; 
    std::cout << "Zeiger c  " << &c << "\t" << c << "\t" << *c << std::endl; 
    

    return 0;
}