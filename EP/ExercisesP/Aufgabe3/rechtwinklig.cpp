#include <iostream>
using namespace std;


int main(){
    int a, b, c, save;

    // input
    cout << "Type three numbers:" << endl;;
    cin >> a;
    cin >> b;
    cin >> c;

    // check if there's no negative or 0 values
    if (a <= 0 || b <= 0 || c <= 0){
        cout << "not all variables are positive.";
        return 1;
    }

    // c has to be the longest.
    if (c >= a && c >= b){

    }else{
        if(c < a && c >= b){
            save = a;
            a = c;
            c = save;
        }else if(c >= a && b > c){
            save = b;
            b = c;
            c = save;
        }else{ // both a and b are bigger(or equal) than c
            if(a <= b){
                save = b;
                b = c;
                c = save;
            }else{
                save = a;
                a = c;
                c = save;
            }
        }
    }
    cout << "a: " << a << endl;
    cout << "b: " << b << endl;
    cout << "c: " << c << endl;

    // see if they are valid
    if (a + b >= c){
        cout << "invalid inputs." << endl;
        return 1;
    }

    // rechtwinklig?
    if(a*a + b*b == c*c ){
        cout << "Yes! Rechtwinklig!" << endl;
    }else{
        cout << "No! Rechtwinklig" << endl;
    }
    return 0;
}