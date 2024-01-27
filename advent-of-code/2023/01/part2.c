#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "str.h"

char *numbers[] = {
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
};

int find_number(const char *line) {
    int matched = 0;
    if (isdigit(*line)) return *line - '0';
    for (int i = 0; i < 10; i++) {
        matched = 1;
        const char *p1 = numbers[i], *p2 = line;
        while (*p1 != '\0' && *p2 != '\0') {
            if (*p1 != *p2) {
                matched = 0;
                break;
            }
            p1++;
            p2++;
        }
        if (matched && *p1 == '\0') return i;
    }
    return -1;
}

int main() {
    FILE* fp = fopen("./input", "r");
    int sum = 0;
    while (1) {
        char *line = str_strip(fgetline(fp));
        if (line == NULL || strlen(line) == 0) {
            break;
        }
        int d1 = -1, d2 = -1;
        while (*line != '\0') {
            int num = -1;
            if ((num = find_number(line)) >= 0) {
                if (d1 == -1) d1 = num;
                d2 = num;
            }
            line++;
        }
        if (d2 == -1) d2 = d1;
        sum += d1 * 10 + d2;
    }
    printf("%d\n", sum);
    return 0;
}

