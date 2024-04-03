#include <iostream>
using namespace std;


int umwandlung(char const isbn){
    if(isbn == 120){
        return isbn-110;
    }else{
        return isbn-48;
    }
}

bool isbn10check(char const isbn[]){
    int sum = 0;
    for(int i = 0; i < 9; i++){
        sum += (i+1)*umwandlung(isbn[i]);
    }
    //cout << "sum: " << sum << endl;
    //cout << "sum % 11: " << sum % 11 << endl;
    return sum % 11 == umwandlung(isbn[9]);
}

int main(){
    char const x1[] = "349913599x";
    char const x2[] = "2871499367";
    //bool isbncheck;
    
    int i = 0;
    int k;
    cout << "check if umwandlung works." << endl;
    cout << "x1 in char array: " << x1 << endl;
    cout << "x1 in integer:    ";
    while(x1[i] != '\0'){
        k = umwandlung(x1[i]);
        cout << k;
        i++;
    }
    cout << endl;
    //isbncheck = isbn10check(x1);
    cout << "1 if isbncheck is true: " << isbn10check(x1) << endl;

    //isbncheck = isbn10check(x2);
    cout << "1 if isbncheck is true: " << isbn10check(x2) << endl;

    return 0;   
}