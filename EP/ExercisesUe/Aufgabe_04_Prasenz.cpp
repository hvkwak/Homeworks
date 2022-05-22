#include <iostream>
using namespace std;

char grossbuch(char x){
    if(97<= x && x <=122){
        return x-32;
    }else{
        return x;
    }
}

// wort1 is a pointer, but works fine. shit. check anagramme.cpp
void inverse(char const wort1[]){
    int i = 0;
    char x;
    while(wort1[i]!='\0'){
        //cout << wort1[i];
        x = grossbuch(wort1[i]);
        cout << x;
        i += 1;
    }
    cout << endl;
    for(int j = i; 0 <= j; j--){
        cout << wort1[j];
    }
}

int main(){
    char const wort1[] = "Nashorn";
    inverse(wort1);
    return 0;
}