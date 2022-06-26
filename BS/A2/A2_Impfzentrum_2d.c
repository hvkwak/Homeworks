#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <semaphore.h>
#include "A2_utils.h"

extern pthread_mutex_t mutex;
extern sem_t sem;

int main(){

    // Note:
    // die Hotlines vergeben einfach einen Termin nach dem anderen.
    // Terminreservierung dauert in der Simulation jeweils 1 Sekunde, danach wird der Termin-Zähler um eins verringert.

    int rest_reservation_num = 50;
    int thread_num = 5;
    int status[thread_num];
    pthread_t hotlines[thread_num];

    // sem_init()
    if(sem_init(&sem, 0, 1) != 0){
        perror("Error: ");
        printf("sem_init() not successful.");
        return 1;
    }

    /*
        d) create, start and exit Threads synchronized with semaphor to solve race condition.
    */
    // init threads
    for(int i = 0; i < thread_num; i++){
        if(pthread_create(&hotlines[i], NULL, &Termin_Vergabe_synchronized_sem, &rest_reservation_num) != 0){
            perror("Error: ");
            printf("%d th pthread_create() not successful.", i);
            return 1;
        }
    }

    // pthread_join
    for(int i = 0; i < thread_num; i++){
        if(pthread_join(hotlines[i], NULL) != 0){
            perror("Error: ");
            printf("%d th pthread_join() not successful.", i);
            return 1;
        }
    }
    printf("rest_reservation_num: %d\n", rest_reservation_num);

    // mutex_destroy()
    if(sem_destroy(&sem) != 0){
        perror("Error: ");
        printf("sem_destroy() not successful.");
        return 1;
    }


    return 0;
}