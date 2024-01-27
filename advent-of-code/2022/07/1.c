#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct dir Dir;

#define LOG(s) fprintf(stderr, s"\n");

struct dir {
    char name[32];
    Dir *parent;
    Dir *next_sibling;
    Dir *child;
    int size;
};

char buf[4096];

Dir root = {0};

int sum = 0;

int totalsize(Dir *dir) {
    if (dir == NULL) return 0;
    int total = dir->size;
    Dir *child = dir->child;
    while (child != NULL) {
        total += totalsize(child);
        child = child->next_sibling;
    }
    if (total <= 100000) sum += total;
    return total;
}

void process_ls(FILE* fp, Dir *cur) {
    while (1) {
        int c = fgetc(fp);
        if (c == EOF) return;
        ungetc(c, fp);
        if (c == '$') {
            return;
        }
        buf[0] = '\0';
        fgets(buf, 4096, fp);
        if (buf[0] == 'd') {
            strtok(buf, " ");
            char *childname = strtok(NULL, "\n");
            Dir *newdir = malloc(sizeof(Dir));
            strcpy(newdir->name, childname);
            newdir->parent = cur;
            newdir->next_sibling = cur->child;
            newdir->child = NULL;
            newdir->size = 0;
            cur->child = newdir;
        } else {
            char *pos;
            long fsz = strtol(buf, &pos, 10);
            cur->size += fsz;
        }
    }
}

void process_cmd(FILE *fp, Dir **pcur) {
    Dir *cur = *pcur;
    char *cmd = strtok(buf + 2, " \n"); 
    if (strcmp(cmd, "cd") == 0) {
        char *param = strtok(NULL, " \n"); 
        if (strcmp(param, "/") == 0) {
            *pcur = &root;
        } else if (strcmp(param, "..") == 0) {
            *pcur = cur->parent;
        } else {
            Dir *t = cur->child;
            while (t != NULL) {
                if (strcmp(t->name, param) == 0) {
                    *pcur = t;
                    break;
                } else {
                    t = t->next_sibling;
                }
            }
        }
    } else if (strcmp(cmd, "ls") == 0) {
        process_ls(fp, cur);
    }
}

int main() {
    FILE *fp = fopen("input", "r");
    Dir *cur = &root;
    while (fgets(buf, 4096, fp)) {
        int len = strlen(buf);
        if (len <= 1) continue;
        char c = buf[0];
        if (c == '$') {
            process_cmd(fp, &cur);
        }
    }
    totalsize(&root);
    printf("%d\n", sum);
}
