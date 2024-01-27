#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include "str.h"


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
            if (isdigit(*line)) {
                if (d1 == -1) d1 = *line - '0';
                d2 = *line - '0';
            }
            line++;
        }
        if (d2 == -1) d2 = d1;
        sum += d1 * 10 + d2;
    }
    printf("%d\n", sum);
    return 0;
}

