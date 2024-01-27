#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include <str.h>

int strength = 1;
int sum = 0;
int time = 1;

int process() {
    if (time == 20 || time == 60 || time == 100
            || time == 140 || time == 180 || time == 220) {
        sum += strength * time;
    }
}

void tick(int value) {
    process();
    time++;
    strength += value;
}

int main() {
    FILE *fp = fopen("input", "r");
    while (true) {
        char *rawline = fgetline(fp);
        if (rawline == NULL) break;
        char *line = str_strip(rawline);
        free(rawline);
        char** words = str_split(line, ' ');
        if (words == NULL) {
            free(line);
            continue;
        }
        if (words[0] == NULL) {
            free(line); free(words);
            continue;
        }
        if (strcmp(words[0], "noop") == 0) {
            tick(0);
        } else if (strcmp(words[0], "addx") == 0) {
            tick(0);
            char *ptr;
            int value = strtol(words[1], &ptr, 10);
            tick(value);
        }
        str_list_free(words);
        free(line);
    }
    printf("%d\n", sum);
    return 0;
}
