#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSZ 1024

char buf[BUFSZ];
int valuetbl[3] = {1, 2, 3};
int wintbl[3][3] = {
    {3, 6, 0},
    {0, 3, 6},
    {6, 0, 3}
};


int score(char a, char b) {
    return valuetbl[b - 'X'] + wintbl[a - 'A'][b - 'X'];
}

int main() {
    FILE *fp = fopen("input", "r");
    if (fp == NULL) return -1;
    int scr = 0;
    while (fgets(buf, BUFSZ, fp)) {
        if (strlen(buf) <= 1) continue;
        scr += score(buf[0], buf[2]);
    }
    printf("%d\n", scr);
    return 0;
}
