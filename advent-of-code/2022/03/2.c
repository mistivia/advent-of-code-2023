#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define BUFSZ 1024

char buf[BUFSZ + 1] = {0};

int table[53] = {0};

int decode(char c) {
    if (c >= 'A' && c <= 'Z') {
        return 26 + c - 'A' + 1;
    }
    if (c >='a' && c <= 'z') {
        return c - 'a' + 1;
    }
    return -1;
}

int process(char *buf, int len, int n) {
    if (n == 1) memset(table, 0, 53 * sizeof(int));
    for (int i = 0; i < len; i++) {
        int code = decode(buf[i]);
        if (table[code] == n - 1) {
            if (n == 3) return code; 
            table[code] = n;
        }
    }
    return 0;
}


int main() {
    FILE *fp = fopen("input", "r");
    int sum = 0;
    if (fp == NULL) return -1;
    int line = 0;
    while (fgets(buf, BUFSZ, fp)) {
        if (strlen(buf) <= 1) continue;
        int len = strlen(buf) - 1;
        sum += process(buf, len, line % 3 + 1);
        line++;
    }
    printf("%d\n", sum);
}
