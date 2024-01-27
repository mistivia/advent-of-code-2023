#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSZ 1024

char buf[BUFSZ];

int main() {
    int maxval = 0;
    int cur = 0;
    FILE* fp = fopen("input", "r");
    while (fgets(buf, BUFSZ, fp)) {
        int len = strlen(buf);
        char *end;
        if (len <= 1) {
            maxval = cur > maxval ? cur : maxval;
            cur = 0;
        } else {
            cur += strtol(buf, &end, 10);
        }
    }
    printf("%d\n", maxval);
    return 0;
}
