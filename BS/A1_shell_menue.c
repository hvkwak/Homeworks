#include <stdio.h>
#include <unistd.h>
#include <wait.h>
#include <stdlib.h>
#include <sys/types.h>

int main(){
    int a;
    int pid;
    char *b = NULL;

    // Einlesen der Standardeingabe
    printf("Enter a Parameter: 0, 1, 2 or 3\n");
    scanf("%d", &a);
    while (a != 0 && a != 1 && a != 2 && a != 3){
        printf("Invalid input. Enter a Parameter: 0, 1, 2 or 3\n");
        scanf("%d", &a);
    }
    if(a == 0){
        b = "pw";
    }else if(a == 1){
        b = "clear";
    }else if(a == 2){
        b = "ls";
    }else if(a == 3){
        exit(3);
    }
    printf("selected parameter: %s\n", b);
    
    // Kindprozess Erzeugen und Befehl laufen lassen
    printf("Elternpr.: PID %d PPID %d\n", getpid(), getppid());
    pid = fork();
    if(pid > 0){
        printf("Im Elternprozess, Kind-PID %d\n", pid);
        int status;
        if (wait(&status) == pid && WIFEXITED(status)){
            printf("Exit Status: %d\n", WEXITSTATUS(status));
            if (WEXITSTATUS(status) == 42){
                printf("program in child process unsuccessful.\n");
                execlp("./shell_menue", "./shell_menue", NULL);
            }else if(WEXITSTATUS(status) == 0){
                printf("program in child process successful.\n");
                execlp("./shell_menue", "./shell_menue", NULL);
            }
        }
    }else if(pid == 0){
        printf("Im Kindprozess, PID %d PPID %d\n", getpid(), getppid());
        execlp(b, b, NULL);
        exit(42);
    }else{
        printf("Error\n");
    }
    return 0;
}