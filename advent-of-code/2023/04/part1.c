#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "vec.h"
#include "str.h"

typedef struct {
    void *win_nums;
    void *nums;
} card_t;

void *parse_input() {
    FILE *fp = fopen("./input", "r");
    void *cards = new_vec();
    char *line;
    while ((line = fgetline(fp)) != NULL) {
        line = str_strip(line);
        line = vec_get(str_split(line, ':'), 1);
        line = str_strip(line);
        void *splited = str_split(line, '|');
        char *win_str = str_strip(vec_get(splited, 0));
        char *num_str = str_strip(vec_get(splited, 1));
        void *winnums_str = str_split(win_str, ' ');
        void *nums_str = str_split(num_str, ' ');

        card_t *card = malloc(sizeof(card_t));
        card->win_nums = new_vec();
        card->nums = new_vec();
        for (int i = 0; i < vec_size(winnums_str); i++) {
            int *n = malloc(sizeof(int));
            *n = strtol(vec_get(winnums_str, i), NULL, 10);
            vec_push_back(card->win_nums, n);
        }
        for (int i = 0; i < vec_size(nums_str); i++) {
            int *n = malloc(sizeof(int));
            *n = strtol(vec_get(nums_str, i), NULL, 10);
            vec_push_back(card->nums, n);
        }
        vec_push_back(cards, card);
    }
    return cards;
}

int points(card_t *card) {
    int win_count = 0;
    for (int i = 0; i < vec_size(card->nums); i++) {
        int num = *(int*)vec_get(card->nums, i);
        for (int j = 0; j < vec_size(card->win_nums); j++) {
            if (num == *(int*)vec_get(card->win_nums, j)) {
                win_count++;
                break;
            }
        }
    }
    if (win_count == 0) return 0;
    return (int)pow(2, win_count - 1);
}

int main() {
    void *cards = parse_input();
    int sum = 0;
    for (int i = 0; i < vec_size(cards); i++) {
        int p = points(vec_get(cards, i));
        sum += p;
    }
    printf("%d\n", sum);
    return 0;
}
