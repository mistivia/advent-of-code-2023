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
    Point knots[10];
} State;

bool is_adjacent(Point p1, Point p2) {
    if (abs(p1.x - p2.x) <= 1 && abs(p2.y - p1.y) <= 1) {
        return true;
    }
    return false;
}

Point catchup(Point prev, Point new) {
    int dx = new.x - prev.x;
    int dy = new.y - prev.y;
    int cx = 0, cy = 0;
    if (dx > 0) cx = 1;
    if (dx < 0) cx = -1;
    if (dy > 0) cy = 1;
    if (dy < 0) cy = -1;
    return (Point){prev.x + cx, prev.y + cy};
}

void run_impl(State *s, HTable *record, int dx, int dy) {
    s->knots[0].x += dx;
    s->knots[0].y += dy;
    for (int i = 1; i < 10; i++) {
        if (is_adjacent(s->knots[i], s->knots[i-1])) {
            continue;
        }
        s->knots[i] = catchup(s->knots[i], s->knots[i-1]);
        if (i == 9) {
            htable_insert(record , &(s->knots[i]));
        }
    }
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
        Point *p = iter;
        count++;
    }
    return count;
}

int main() {
    FILE *fp = fopen("input", "r");
    State state = {0};
    char direction;
    int step;
    HTable record;
    htable_init(&record, sizeof(Point), -1, point_hash, point_eq);
    htable_insert(&record, &state.knots[9]);
    while (fscanf(fp, "%c %d", &direction, &step) != EOF) {
        run(&state, &record, direction, step);
    }
    int count = count_htable(&record);
    printf("%d\n", count);
    return 0;
}

