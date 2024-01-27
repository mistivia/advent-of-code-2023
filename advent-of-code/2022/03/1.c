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

int findcommon(char *buf, int len) {
    memset(table, 0, 53 * sizeof(int));
    len = len / 2;
    for (int i = 0; i < len; i++) {
        int code = decode(buf[i]);
        if (table[code] == 0) {
            table[code] = 1;
        }
    }
    for (int i = 0; i < len; i++) {
        int code = decode(buf[i + len]);
        if (table[code] == 1) return code;
    }
    return 0;
}

int main() {
    FILE *fp = fopen("input", "r");
    int sum = 0;
    if (fp == NULL) return -1;
    while (fgets(buf, BUFSZ, fp)) {
        if (strlen(buf) <= 1) continue;
        int len = strlen(buf) - 1;
        assert((len % 2 == 0) && "len error");
        int common = findcommon(buf, len);
        sum += common;
    }
    printf("%d\n", sum);
}
