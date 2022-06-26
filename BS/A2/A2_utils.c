#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

pthread_mutex_t mutex;
sem_t sem;
/*
int all_zero(int arr[], int arr_size){
    // or int * arr
    int sum = 0;
    for(int i = 0; i < arr_size; i++){
        sum += arr[i];
    }
    return sum == 1;
}
*/

// Note:
// die Hotlines vergeben einfach einen Termin nach dem anderen.
// Terminreservierung dauert in der Simulation jeweils 1 Sekunde, danach wird der Termin-Zähler um eins verringert.

void* Termin_Vergabe_unsynchronized(void *arg){
    //
    // let thread make reservations. See they reach the common data and make reservations more than it's allowed.
    //
    while(*(int *)arg > 0){
        sleep(1); // Terminvergabe
        *(int *)arg -= 1;
        printf("rest_reservation_num after Termin_Vergabe(): %d\n", *(int *)arg);
    }
    pthread_exit(NULL);
}

void* Termin_Vergabe_synchronized_mutex(void *arg){
    //
    // let thread make reservations. Note that threads should terminate when they run out of available reservation slots.
    //
    while(*(int *)arg){
        pthread_mutex_lock(&mutex);
        if(*(int *)arg > 0){
            *(int *)arg -= 1;
            sleep(1); // Terminvergabe
            printf("rest_reservation_num after Termin_Vergabe(): %d\n", *(int *)arg);
        }
        pthread_mutex_unlock(&mutex);
    }
    pthread_exit(NULL);
}

void* Termin_Vergabe_synchronized_sem(void *arg){
    //
    // let thread make reservations. Note that threads should terminate when they run out of available reservation slots.
    //
    while(*(int *)arg){
        sem_wait(&sem);
        if(*(int *)arg > 0){
            *(int *)arg -= 1;
            sleep(1); // Terminvergabe
            printf("rest_reservation_num after Termin_Vergabe(): %d\n", *(int *)arg);
        }
        sem_post(&sem);
    }
    pthread_exit(NULL);
}