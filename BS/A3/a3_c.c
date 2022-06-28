#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
// Zusätzliche Header-Dateien hier!
#include <time.h>
#include "vorgabe.h"

void *work(void *arg)
{
	int my_num = *((int *)arg);

	printf("[A%d] Ich bin bereit zu Graben!\n", my_num);

	// *** HIER EUER CODE ***

	// all excavation steps now knowable!
	// init bag
	ExcavationStep next_step;
	int bag[TOOL_COUNT];
	for(int i = 0; i < TOOL_COUNT; i++){
		bag[i] = 0;
	}// init bag with 0

	// arrange all the excavation steps:
	int excavation_steps[100];
	int k = 0;
	for(int i = 0; i < EXCAVATIONS_PER_ARCHAEOLOGIST; i++){
		do{
			next_step = get_next_step();
			excavation_steps[k] = next_step.toolIndex;
			k++;
		}while(!next_step.finished);
	}
	// check if k is valid. we note the end of excavations with -1.
	if(k >= 100){
		printf("k > 100");
		exit(1);
	}else{
		excavation_steps[k] = -1;
	}
	
	// gather equipments and finish the excavation.
	pthread_mutex_lock(&lock);
	int i = 0;
	while(excavation_steps[i] != -1){
		if(bag[excavation_steps[i]] == 0){
			sem_wait(&tools[excavation_steps[i]].sem);
			bag[excavation_steps[i]] += 1;
		}
		i++;
	}
	pthread_mutex_unlock(&lock);

	return_all_equipments(bag, TOOL_COUNT);
	printf("Alle Ausgrabungen von [A%d] sind fertig\n", my_num);
	return NULL;
}
