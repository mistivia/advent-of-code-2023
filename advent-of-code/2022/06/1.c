#include <stdio.h>
#include <stdbool.h>

bool succ(char *buf) {
    bool table[26] = {0};
    for (int i = 0; i < 4; i++) {
        if(!table[buf[i] - 'a']) table[buf[i] - 'a'] = true;
        else return false;
    }
    return true;
}

int main() {
    FILE *fp = fopen("input", "r");
    char buf[4] = {0};
    int i = 0;
    int c;
    while ((c = fgetc(fp)) != EOF) {
        if (c < 'a' || c > 'z') continue;
        buf[i % 4] = c;
        if (i >= 4 && succ(buf)) break;
        i++;
    }
    printf("%d\n", i+1);
    return 0;
}
