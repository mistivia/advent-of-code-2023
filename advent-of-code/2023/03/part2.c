#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

#include "vec.h"
#include "str.h"
#include "map.h"

void* read_input() {
    FILE* fp = fopen("./input", "r");
    void *vec = new_vec();
    while(1) {
        char *line = fgetline(fp);
        if (line == NULL) break;
        char *stripped = str_strip(line);
        if (strlen(stripped) == 0) break;
        vec_push_back(vec, stripped);
    }
    return vec;
}

typedef struct {
    int line;
    int column;
    int value;
    int length;
} num_t;

char *compose_key(int x, int y) {
    void* ss = new_ss();
    ss_add(ss, "%d,%d", x, y);
    return ss_cstr(ss);
}

void *parse_nums(void *schema) {
    void *nums = new_vec();
    int j = 0;
    const int IN_NUM = 0, IDLE = 1;
    int state = IDLE;
    for (int i = 0; i < vec_size(schema); i++) {
        char *line = vec_get(schema, i);
        int line_len = strlen(line);
        int value = 0;
        int length = 0;
        state = IDLE;
        j = 0;
        while (1) {
            char c = '.';
            if (j < line_len) c = line[j];
            if (state == IDLE) {
                if (isdigit(c)) {
                    state = IN_NUM;
                    continue;
                } else {
                    j++;
                    if (j >= line_len) break;
                    continue;
                }
            } else if (state == IN_NUM) {
                if (isdigit(c)) {
                    value = value * 10 + (c - '0'); 
                    length++;
                    j++;
                    continue;
                } else {
                    num_t *n = malloc(sizeof(num_t));
                    *n = (num_t){
                        .line = i,
                        .column = j - length,
                        .value = value,
                        .length = length
                    };
                    vec_push_back(nums, n);
                    value = 0;
                    length = 0;
                    state = IDLE;
                    if (j >= line_len) break;
                    continue;
                }
            }
        }
    }
    return nums;
}

char char_at(void *schema, int line, int column) {
    char *buf = vec_get(schema, line);
    return buf[column];
}

void mark_asterisks(void *asterisks, num_t *num, int x, int y) {
    const char *key = compose_key(x, y);
    void *num_list = dict_get(asterisks, key);
    if (num_list == NULL) {
        num_list = new_vec();
        dict_set(asterisks, key, num_list);
    }
    vec_push_back(num_list, num);
}

void find_asterisks(void *schema, void *asterisks, num_t *num) {    
    int line_len = vec_size(schema);
    int col_len = strlen(vec_get(schema, 0));
    for (int i = num->column - 1; i < num->column + num->length + 1; i++) {
        if (num->line - 1 < 0) continue;
        if (i < 0 || i >= col_len) continue;
        char c = char_at(schema, num->line - 1, i);
        if (c == '*') mark_asterisks(asterisks, num, num->line - 1, i);
    }
    for (int i = num->column - 1; i < num->column + num->length + 1; i++) {
        if (num->line + 1 >= line_len) continue;
        if (i < 0 || i >= col_len) continue;
        char c = char_at(schema, num->line + 1, i);
        if (c == '*') mark_asterisks(asterisks, num, num->line + 1, i);
    }
    if (num->column - 1 >= 0) {
        char c = char_at(schema, num->line, num->column - 1);
        if (c == '*') mark_asterisks(asterisks, num, num->line, num->column - 1);
    }
    if (num->column + num->length < col_len) {
        char c = char_at(schema, num->line, num->column + num->length);
        if (c == '*') mark_asterisks(asterisks, num, num->line, num->column + num->length);
    }
}

int main() {
    void *schema = read_input();
    void *nums = parse_nums(schema);
    int sum = 0;
    void *asterisks = new_dict();
    for (int i = 0; i < vec_size(nums); i++) {
        num_t *num = vec_get(nums, i);
        find_asterisks(schema, asterisks, num);
    }
    for (void *iter = dict_begin(asterisks);
            iter != NULL;
            iter = dict_next(asterisks, iter)) {
        void *list = dict_iter_value(iter);
        if (vec_size(list) == 2) {
            num_t* n1 = vec_get(list, 0);
            num_t* n2 = vec_get(list, 1);
            sum += n1->value * n2->value;
        }
    }
    printf("%d\n", sum);
    return 0;
}
