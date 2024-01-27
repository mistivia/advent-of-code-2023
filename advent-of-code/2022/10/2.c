#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#include <str.h>

char screen[6][40];

int regx = 0;
int time = 0;

void process() {
    if (time >= 240) return;
    int delta = time % 40 - regx;
    if (delta <= 2 && delta >= 0) {
        screen[time / 40][time % 40] = '#';
    }
}

void tick(int value) {
    process();
    time++;
    regx += value;
}

int main() {
    memset(screen, '.', 240);
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
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 40; j++) {
            printf("%c", screen[i][j]);
        }
        printf("\n");
    }
    return 0;
}
