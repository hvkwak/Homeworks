#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
// Zusätzliche Header-Dateien hier!

#include "vorgabe.h"


void *work(void *arg)
{
	int my_num = *((int *)arg);

	printf("[A%d] Ich bin bereit zu Graben!\n", my_num);

	// *** HIER EUER CODE ***
	// Note that this will lead to Deadlock(Verklemmungen).
	ExcavationStep next_step;
	int bag[TOOL_COUNT];
	for(int i = 0; i < TOOL_COUNT; i++){
		bag[i] = 0;
	}

	// work!
	for(int i = 0; i < EXCAVATIONS_PER_ARCHAEOLOGIST; i++){
		// plan the next step
		do {
			next_step = get_next_step();
			if(bag[next_step.toolIndex] == 0){
				// 1. Semaphor tool belegen
				sem_wait(&tools[next_step.toolIndex].sem);
				bag[next_step.toolIndex] += 1;
			}
			sleep(next_step.time); // excavation takes place
		}while(!next_step.finished);
	}
	printf("Alle Ausgrabungen von [A%d] sind fertig\n", my_num);

	// bring all the equipments back
	return_all_equipments(bag, TOOL_COUNT);
	return NULL;
}
