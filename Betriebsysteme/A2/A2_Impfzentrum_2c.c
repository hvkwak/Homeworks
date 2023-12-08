#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include "A2_utils.h"

extern pthread_mutex_t mutex;

int main(){

    // Note:
    // die Hotlines vergeben einfach einen Termin nach dem anderen.
    // Terminreservierung dauert in der Simulation jeweils 1 Sekunde, danach wird der Termin-Zähler um eins verringert.

    int rest_reservation_num = 50;
    int thread_num = 5;
    int status[thread_num];
    pthread_t hotlines[thread_num];
    
    // pthread_mutex_init()
    if(pthread_mutex_init(&mutex, NULL) != 0){
        perror("Error: ");
        printf("mutex_init() not successful.");
        exit(-1);
    }

    /*
        c) create, start and exit Threads synchronized with mutex to solve race condition.
    */
    // init threads
    for(int i = 0; i < thread_num; i++){
        if(pthread_create(&hotlines[i], NULL, &Termin_Vergabe_synchronized, &rest_reservation_num) != 0){
            perror("Error: ");
            printf("%d th pthread_create() not successful.", i);
            exit(-1);
        }
    }

    // pthread_join
    for(int i = 0; i < thread_num; i++){
        if(pthread_join(hotlines[i], NULL) != 0){
            perror("Error: ");
            printf("%d th pthread_join() not successful.", i);
            exit(-1);
        }
    }
    printf("rest_reservation_num: %d\n", rest_reservation_num);

    // mutex_destroy()
    if(pthread_mutex_destroy(&mutex) != 0){
        perror("Error: ");
        printf("mutex_init() not successful.");
        exit(-1);
    }


    return 0;
}