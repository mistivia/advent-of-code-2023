#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSZ 1024

char buf[BUFSZ];

int maxheap[3] = {0, 0, 0};

void push(int val) {
    int minidx = 0;
    for (int i = 0; i < 3; i++) {
        if (maxheap[i] < maxheap[minidx]) {
            minidx = i;
        }
    }
    if (maxheap[minidx] < val) {
        maxheap[minidx] = val;
    }
}

int main() {
    int maxval = 0;
    int cur = 0;
    FILE* fp = fopen("input", "r");
    while (fgets(buf, BUFSZ, fp)) {
        int len = strlen(buf);
        char *end;
        if (len <= 1) {
            maxval = cur > maxval ? cur : maxval;
            push(cur);
            cur = 0;
        } else {
            cur += strtol(buf, &end, 10);
        }
    }
    printf("%d\n", maxheap[0] + maxheap[1] + maxheap[2]);
    return 0;
}

