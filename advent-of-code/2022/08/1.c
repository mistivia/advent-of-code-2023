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

int get(Mat *m, int row, int column) {
    return m->data[row * m->columns + column];
}

void set(Mat *m, int row, int column, uint8_t value) {
    m->data[row * m->columns + column] = value;
}

char buf[4096];

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
    
    Mat vis = m;
    vis.data = malloc(m.rows * m.columns);
    vis.cap = m.rows * m.columns;
    memset(vis.data, 0, vis.cap);
    
    // top-down scan
    for (int i = 0; i < m.columns; i++) {
        int curmax = -1;
        for (int j = 0; j < m.rows; j++) {
            if (get(&m, j, i) > curmax) {
                set(&vis, j, i, 1);
                curmax = get(&m, j, i);
            }
        }
    }
    // down-top scan
    for (int i = 0; i < m.columns; i++) {
        int curmax = -1;
        for (int j = m.rows - 1; j >= 0; j--) {
            if (get(&m, j, i) > curmax) {
                set(&vis, j, i, 1);
                curmax = get(&m, j, i);
            }
        }
    }
    
    // left-right scan
    for (int i = 0; i < m.rows; i++) {
        int curmax = -1;
        for (int j = 0; j < m.columns; j++) {
            if (get(&m, i, j) > curmax) {
                set(&vis, i, j, 1);
                curmax = get(&m, i, j);
            }
        }
    }
    
    // right-left scan
    for (int i = 0; i < m.rows; i++) {
        int curmax = -1;
        for (int j = m.columns - 1; j >= 0; j--) {
            if (get(&m, i, j) > curmax) {
                set(&vis, i, j, 1);
                curmax = get(&m, i, j);
            }
        }
    }
    
    // count
    int count = 0;
    for (int i = 0; i < m.columns; i++) {
        int curmax = -1;
        for (int j = 0; j < m.rows; j++) {
            if (get(&vis, j, i) > 0) {
                count++;
            }
        }
    }
    
    printf("%d", count);
    return 0;
}

