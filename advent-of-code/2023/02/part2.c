#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>

#include "str.h"
#include "vec.h"

typedef struct {
    int r,g,b;
} set_t;

typedef struct {
    int length;
    set_t sets[64];
} game_t;

game_t games[100];

void parse_set(const char *str, set_t *set) {
    void* strs = str_split(str, ',');
    set->r = 0;
    set->g = 0;
    set->b = 0;
    for (int i = 0; i < vec_size(strs); i++) {
        char *str = vec_get(strs, i);
        void* infos = str_split(str, ' ');
        if (strcmp(vec_get(infos, 1), "red") == 0) {
            set->r = strtol(vec_get(infos, 0), NULL, 10);
        } else if (strcmp(vec_get(infos, 1), "blue") == 0) {
            set->b = strtol(vec_get(infos, 0), NULL, 10);
        } else if (strcmp(vec_get(infos, 1), "green") == 0) {
            set->g = strtol(vec_get(infos, 0), NULL, 10);
        }
    }
}

void parse_game(const char *line, game_t *game) {
    void *strs = str_split(line, ':');
    void *sets_str = str_split(vec_get(strs, 1), ';');
    for (int i = 0; i < vec_size(sets_str); i++) {
        set_t s;
        parse_set(str_strip(vec_get(sets_str, i)), &s);
        game->sets[i] = s;
    }
    game->length = vec_size(sets_str);
}

int power(game_t *game) {
    int maxr = 0;
    int maxg = 0;
    int maxb = 0;
    for (int i = 0; i < game->length; i++) {
        if (game->sets[i].r > maxr) maxr = game->sets[i].r;
        if (game->sets[i].g > maxg) maxg = game->sets[i].g;
        if (game->sets[i].b > maxb) maxb = game->sets[i].b;
    }
    return maxr * maxg * maxb;
}

int main() {
    FILE *fp = fopen("./input", "r");
    int sum = 0;
    for (int i = 0; i < 100; i++) {
        char *line = fgetline(fp);
        parse_game(line, &games[i]);
    }
    for (int i = 0; i < 100; i++) {
        sum += power(&games[i]);
    }
    printf("%d\n", sum);    
    return 0;
}
