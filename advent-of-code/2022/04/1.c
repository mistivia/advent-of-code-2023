#include <stdio.h>

int main() {
    FILE *fp = fopen("input", "r");
    int x1, x2, y1, y2;
    int count = 0;
    while (fscanf(fp, "%d-%d,%d-%d", &x1, &x2, &y1, &y2) != EOF) {
        if (x1 <= y1 && x2 >= y2 || x1 >= y1 && x2 <= y2) {
            count++;
        }
    }
    printf("%d\n", count);
    return 0;
}
