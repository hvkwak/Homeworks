#include <stdlib.h>
#include <stdio.h>

int fak(int n){
    if(n == 1){
        return 1;
    }else{
        return n*fak(n-1);
    }
}


int main(int argc, char* argv[]){
    // argc is the number of arguments, e.g.) ./add 3, 2, 5 -> argc = 4
    // argv[] contains all the arguments in string, where ./add is at position 0.
    if(argc == 1){
        printf("Keine Obergrenze angegeben");
    }else if(argc > 2){
        printf("Zu viele Angabe. Geben Sie nur eine Zahl ein.");
    }else{
        if(atoi(argv[1]) < 1){
            printf("Fehler: Negative Zahl");
        }else{
            printf("Die Fakultaet von %s lautet: %d", argv[1], fak(atoi(argv[1])));
        }
    }
    return 0;
}