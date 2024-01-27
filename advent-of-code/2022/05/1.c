#include <stdio.h>
#include <stdlib.h>

struct listnode {
    struct listnode *next;
    char val;
};
typedef struct {
    struct listnode *head;
} Stack;

void stack_push(Stack *s, char val) {
    struct listnode *n = malloc(sizeof(struct listnode));
    n->next = s->head;
    n->val = val;
    s->head = n;
}

char* stack_top(Stack *s) {
    if (s->head == NULL) return NULL;
    return &(s->head->val);
}

void stack_pop(Stack *s) {
    if (s->head == NULL) return;
    struct listnode *next = s->head->next;
    free(s->head);
    s->head = next;
}

char buf[4096];

int main() {
    Stack s[9];
    FILE *fp = fopen("input", "r");
    fread(buf, 1, 36 * 8, fp);
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 8; j++) {
            char c = buf[(7 - j) * 36 + i * 4 + 1];
            if (c != ' ') {
                stack_push(&s[i], c);
            }
        }
    }
    fgets(buf, 4096, fp);
    fgets(buf, 4096, fp);
    int amount, from, to;
    while (fscanf(fp, "move %d from %d to %d\n", &amount, &from, &to) > 0) {
        for (int i = 0; i < amount; i++) {
            char c = *stack_top(&s[from - 1]);
            stack_pop(&s[from - 1]);
            stack_push(&s[to - 1], c);
        }
    }
    for (int i = 0; i < 9; i++) {
        printf("%c", *stack_top(&s[i]));
    }
    printf("\n");
    return 0;
}
