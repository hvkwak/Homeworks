#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include "A2_utils.h"

int main(){

    int rest_reservation_num = 50;
    int thread_num = 6;
    pthread_t hotlines[thread_num];

    /*
        a) create, start and exit Threads unsynchronized.
    */
    // init threads
    for(int i = 0; i < thread_num; i++){
        if (pthread_create(&hotlines[i], NULL, &Termin_Vergabe_unsynchronized, &rest_reservation_num) != 0){
            perror("Error: ");
            printf("%d th pthread_create() not successful.", i);
            exit(0);
        }
    }

    // pthread_join
    for(int i = 0; i < thread_num; i++){
        if (pthread_join(hotlines[i], NULL) != 0){
            perror("Error: ");
            printf("%d th pthread_join() not successful.", i);
            exit(0);
        }
    }
    printf("rest_reservation_num: %d\n", rest_reservation_num);
    /*
        c) Synchronisation - mutex
    */
    

    /*
        d) Semaphor-Synchronisation
    */



    return 0;
}
