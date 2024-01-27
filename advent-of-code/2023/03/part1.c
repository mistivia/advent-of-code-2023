#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

#include "vec.h"
#include "str.h"

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

int is_symbol(char c) {
    if (c >= '0' && c <= '9') return 0;
    if (c == '.') return 0;
    return 1;
}

int is_a_part(void *schema, num_t *num) {    
    int line_len = vec_size(schema);
    int col_len = strlen(vec_get(schema, 0));
    for (int i = num->column - 1; i < num->column + num->length + 1; i++) {
        if (num->line - 1 < 0) continue;
        if (i < 0 || i >= col_len) continue;
        if (is_symbol(((char*)vec_get(schema, num->line - 1))[i])) {
            return 1;
        }
    }
    for (int i = num->column - 1; i < num->column + num->length + 1; i++) {
        if (num->line + 1 >= line_len) continue;
        if (i < 0 || i >= col_len) continue;
        if (is_symbol(((char*)vec_get(schema, num->line + 1))[i])) {
            return 1;
        }
    }
    if (num->column - 1 >= 0) {
        if (is_symbol(((char*)vec_get(schema, num->line))[num->column - 1])) {
            return 1;
        }
    }
    if (num->column + num->length < col_len) {
        char *line = vec_get(schema, num->line);
        if (is_symbol(line[num->column + num->length])) {
            return 1;
        }
    }
    return 0;
}

int main() {
    void *schema = read_input();
    void *nums = parse_nums(schema);
    int sum = 0;
    for (int i = 0; i < vec_size(nums); i++) {
        num_t *num = vec_get(nums, i);
        if (is_a_part(schema, num)) {
            sum += num->value;
        }
    }
    printf("%d\n", sum);
    return 0;
}
