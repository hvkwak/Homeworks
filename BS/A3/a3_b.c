#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
// Zusätzliche Header-Dateien hier!
#include <time.h>

#include "vorgabe.h"
struct timespec waittime;

void *work(void *arg)
{
	int my_num = *((int *)arg);

	printf("[A%d] Ich bin bereit zu Graben!\n", my_num);

	// *** HIER EUER CODE ***
	ExcavationStep next_step;
	int bag[TOOL_COUNT];
	for(int i = 0; i < TOOL_COUNT; i++){
		bag[i] = 0;
	}
	if(clock_gettime(CLOCK_REALTIME, &waittime)){
		perror("clock_gettime");
		exit(1);
	}
	waittime.tv_sec += 10;

	// work!
	for(int i = 0; i < EXCAVATIONS_PER_ARCHAEOLOGIST; i++){
		// plan the next step
		do {
			next_step = get_next_step();
			if(bag[next_step.toolIndex] == 0){
				// 1. Semaphor tool belegen
				if(sem_timedwait(&tools[next_step.toolIndex].sem, &waittime) != 0){
					// returns all the equipments and start over -> i--;
					return_all_equipments(bag, TOOL_COUNT);
					sleep(1);
					i--;
					break;
				}else{
					bag[next_step.toolIndex] += 1;
				}
				
			}
			sleep(next_step.time); // excavation takes place
		}while(!next_step.finished);
	}
	printf("Alle Ausgrabungen von [A%d] sind fertig\n", my_num);
	return_all_equipments(bag, TOOL_COUNT);
	return NULL;
}
