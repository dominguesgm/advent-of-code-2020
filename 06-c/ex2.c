#include <stdio.h>
#include <stdlib.h>

#define ARRAY_LENGTH 26
#define COUNT_START 97

int countArrayInstances(int array[], int numberOfAnswers) {
    int tempAcc = 0;
    for(int i = 0; i < ARRAY_LENGTH; i++) {
        if(array[i] == numberOfAnswers) {
            tempAcc += 1;
        }

        array[i] = 0;
    }

    return tempAcc;
}

void main() {
    int array[ARRAY_LENGTH];

    for(int i = 0; i < ARRAY_LENGTH; i++) {
        array[i] = 0;
    }

    FILE * fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;

    fp = fopen("./data.txt", "r");

    if(fp == NULL) {
        exit(EXIT_FAILURE);
    }

    int acc = 0;
    int numberOfAnswers = 0;

    while((read = getline(&line, &len, fp)) != -1) {
        if(read == 1 && line[0] == '\n') {
            int tempAcc = countArrayInstances(array, numberOfAnswers);

            acc += tempAcc;
            numberOfAnswers = 0;
            continue;
        }

        numberOfAnswers++;

        for(int i = 0; i < read - 1; i++) {
            int index = line[i] - 97;
            array[index] += 1;
        }
    }

    acc += countArrayInstances(array, numberOfAnswers);

    printf("Result: %d\n", acc);
}