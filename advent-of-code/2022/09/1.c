#include <stdio.h>
#include <stdlib.h>

#include <htable.h>
#include <crc32.h>

typedef struct {
    int x;
    int y;
} Point;

uint32_t point_hash(void *point) {
    return crc32(0, point, sizeof(Point));
}

bool point_eq(void *x, void *y) {
    Point *a = x, *b = y;
    return (a->x == b->x) && (a->y == b->y);
}

typedef struct {
    Point head;
    Point tail;
} State;

bool is_adjacent(Point p1, Point p2) {
    if (abs(p1.x - p2.x) <= 1 && abs(p2.y - p1.y) <= 1) {
        return true;
    }
    return false;
}

void run_impl(State *s, HTable *record, int dx, int dy) {
    Point new = {s->head.x + dx, s->head.y + dy};
    if (!is_adjacent(s->tail, new)) {
        s->tail = s->head;
        htable_insert(record , &(s->tail));
    }
    s->head = new;
}

void run(State *s, HTable *record, char direction, int step) {
    int dx, dy;
    switch (direction) {
        case 'U':
            dx = 0; dy = 1;
            break;
        case 'D':
            dx = 0; dy = -1;
            break;
        case 'L':
            dx = -1; dy = 0;
            break;
        case 'R':
            dx = 1; dy = 0;
            break;
        default:
            return;
    }
    for (int i = 0; i < step; i++) {
        run_impl(s, record, dx, dy);
    }
}

int count_htable(HTable *ht) {
    int count = 0;
    for (void *iter = htable_begin(ht);
            iter != NULL;
            iter = htable_next(ht, iter)) {
        count++;
    }
    return count;
}

int main() {
    FILE *fp = fopen("input", "r");
    State state;
    state.head = (Point){0, 0};
    state.tail = (Point){0, 0};
    char direction;
    int step;
    HTable record;
    htable_init(&record, sizeof(Point), -1, point_hash, point_eq);
    while (fscanf(fp, "%c %d", &direction, &step) != EOF) {
        run(&state, &record, direction, step);
    }
    int count = count_htable(&record);
    printf("%d\n", count);
    return 0;
}

