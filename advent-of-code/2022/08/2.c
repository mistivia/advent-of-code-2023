#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    uint8_t *data;
    int rows;
    int columns;
    int cap;
} Mat;



char buf[4096];

int get(Mat *m, int row, int column) {
    return m->data[row * m->columns + column];
}

int score(Mat *m, int i, int j) {
    int height = get(m, i, j);
    int s = 1;
    int count = 0;
    for (int p = i - 1; p >= 0; p--) {
        count++;
        if (get(m, p, j) >= height) break;
    }
    s *= count;
    count = 0;
    for (int p = i + 1; p < m->rows; p++) {
        count++;
        if (get(m, p, j) >= height) break;
    }
    s *= count;
    count = 0;
    for (int p = j - 1; p >= 0; p--) {
        count++;
        if (get(m, i, p) >= height) break;
    }
    s *= count;
    count = 0;
    for (int p = j + 1; p < m->columns; p++) {
        count++;
        if (get(m, i, p) >= height) break;
    }
    s *= count;
    return s;
}

int main() {
    Mat m;
    m.data = malloc(4096);
    m.cap = 4096;
    m.rows = 0;
    m.columns = 0;

    FILE *fp = fopen("input", "r");
    while(fgets(buf, 4096, fp)) {
        int len = strlen(buf);
        if (len <= 1) break;
        if (m.columns == 0) m.columns = len - 1;
        while (m.cap < (m.rows + 1) * m.columns) {
            m.data = realloc(m.data, m.cap * 2);
            m.cap *= 2;
        }
        memcpy(m.data + m.rows * m.columns, buf, m.columns);
        m.rows++;
    }

    int maxscore = -1;
    for (int i = 0; i < m.rows; i++) {
        for (int j = 0; j < m.columns; j++) {
            int s = score(&m, i, j);
            if (s > maxscore) maxscore = s;
        }
    }

    printf("%d", maxscore);
    return 0;
}

