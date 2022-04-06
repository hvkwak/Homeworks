#include <iostream>
using namespace std;

void show_results(char *x, short a, short b[], short *x1, short *x2, short **y1, short **y2){
    
    cout << "----------------------------------------------" << endl;
    cout << x << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&a: " << &a << endl;
    cout << "a: " << a << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&b: {" << &b[0] << ", "<< &b[1] << ", " << &b[2] << "}" << endl;
    cout << "b: {" << b[0] << ", "<< b[1] << ", " << b[2] << "}" << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&x1: " << &x1 << endl;
    cout << "x1: " << x1 << endl;
    cout << "*x1: " << *x1 << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&x2: " << &x2 << endl;
    cout << "x2: " << x2 << endl;
    cout << "*x2: " << *x2 << endl;
    cout << "----------------------------------------------" << endl;
    cout << "y1: " << y1 << endl;
    cout << "*y1: " << *y1 << endl;
    cout << "**y1: " << **y1 << endl;
    cout << "----------------------------------------------" << endl;
    cout << "y2: " << y2 << endl;
    cout << "*y2: " << *y2 << endl;
    cout << "**y2: " << **y2 << endl;
    cout << "----------------------------------------------" << endl;
}

int main() {

    short a = 11;
    short b[] = {87, 131, 81};
    short *x1 = nullptr;
    short *x2 = nullptr;
    short **y1 = nullptr;
    short **y2 = nullptr;
                                // x1                         x2                         y1          *y1        **y1
    x1 = &a;                    // x1 = &a,    *x1 = 11
    x2 = x1;                    // x1 = &a,    *x1 = 11,      x2 = &a,      *x2 = 11
    x1 = &b[1];                 // x1 = &b[1], *x1 = 131,     
    x2 = x1-1;                  //                            x2 = &b[0],   *x2 = 87
    y1 = &x2;                   //                                                       y1 = &x2,   *y1 = x2   **y1 = 87
    *y1 = x1;
    
    /*
    cout << "----------------------------------------------" << endl;
    cout << "AFTER *y1 = x1;" << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&a: " << &a << endl;
    cout << "a: " << a << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&b: {" << &b[0] << ", "<< &b[1] << ", " << &b[2] << "}" << endl;
    cout << "b: {" << b[0] << ", "<< b[1] << ", " << b[2] << "}" << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&x1: " << &x1 << endl;
    cout << "x1: " << x1 << endl;
    cout << "*x1: " << *x1 << endl;
    cout << "----------------------------------------------" << endl;
    cout << "&x2: " << &x2 << endl;
    cout << "x2: " << x2 << endl;
    cout << "*x2: " << *x2 << endl;
    cout << "----------------------------------------------" << endl;
    cout << "y1: " << y1 << endl;
    cout << "*y1: " << *y1 << endl;
    */
    //cout << "**y1: " << **y1 << endl;
    //cout << "----------------------------------------------" << endl;
    //cout << "y2: " << y2 << endl;
    //cout << "*y2: " << *y2 << endl;
    //cout << "**y2: " << **y2 << endl;
    //cout << "----------------------------------------------" << endl;
    y2 = y1;
    char *x = "After y2 = y1";
    show_results(x, a, b, x1, x2, y1, y2);
    y1 = &x1;
    x1 = &a;
    *x2 = a**(*y2+1);
    **y1 = 1;
    *(x2-1) = **y2+(*(*y2+*x1))+3;
    return 0;
}