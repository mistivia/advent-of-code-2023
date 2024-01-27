// Copyright (C) 2023 Mistivia <i@mistivia.com>
// Licensed under GPLv3. See LICENSE for details.

#include "str.h"

#include <ctype.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "vec.h"

void *str_split(const char *str, char delim) {
    void* ret = new_vec();

    if (str == NULL) return NULL;
    if (*str == '\n') {
        return ret;
    }
    int count = 0;
    const char *begin = str;
    for (const char *p = str; *p != '\0'; p++) {
        if (*p != delim && !(delim == '\0' && isspace(*p))) {
            continue;
        }
        int size = p - begin;
        if (size > 0) count++;
    }
    count++;

    begin = str;
    int i = 0;
    bool finished = false;
    for (const char *p = str; !finished; p++) {
        if (*p == '\0') finished = true;
        if (*p != delim && *p != '\0' && !(delim == '\0' && isspace(*p))) {
            continue;
        }
        int size = p - begin;
        if (size == 0) {
            begin = p + 1;
            continue;
        }
        char *buf = malloc(sizeof(char) * (size + 1));
        buf[size] = '\0';
        memcpy(buf, begin, size * sizeof(char));
        begin = p + 1;
        vec_push_back(ret, buf);
    }
    return ret;
}

char *str_strip(const char *str) {
    if (str == NULL) return NULL;
    int len = strlen(str);
    const char *begin = str;
    const char *end = str + len - 1;
    while (isspace(*begin) && begin < end) {
        begin++;
    }
    while (isspace(*end) && end >= begin) {
        end--;
    }
    len = end - begin + 1;
    char *buf = malloc(sizeof(char) * (len) + 1);
    buf[len] = '\0';
    memcpy(buf, begin, len);
    return buf;
}

typedef struct {
    size_t size;
    size_t cap;
    char *buf;
} str_builder_t;

// string stream
void* new_ss() {
    str_builder_t *self = malloc(sizeof(str_builder_t));
    *self = (str_builder_t){.size = 0, .cap = 16};
    self->buf = malloc(sizeof(char) * 17);
    return self;
}

static void ss_reserve(str_builder_t *self, int extra) {
    if (self->size + extra <= self->cap) {
        return;
    }
    int new_cap = (self->size + extra) * 2;
    self->buf = realloc(self->buf, new_cap + 1);
    memset(self->buf + self->cap, 0, new_cap - self->cap + 1);
    self->cap = new_cap;
}

void ss_add(void *self_, char *format, ...) {
    str_builder_t *self = self_;
    va_list va1;
    va_list va2;
    va_start(va1, format);
    va_copy(va2, va1);
    int size = vsnprintf(NULL, 0, format, va1);
    ss_reserve(self, size);
    vsnprintf(self->buf + self->size, self->cap - self->size + 1, format, va2);
    self->size += size;
}

void ss_addc(void *self_, char c) {
    str_builder_t *self = self_;
    ss_reserve(self, 1);
    self->buf[self->size] = c;
    self->size++;
}

char *ss_cstr(void *self_) {
    str_builder_t *self = self_;
    return self->buf;    
}

size_t ss_size(void *self_) {
    str_builder_t *self = self_;
    return self->size;
}

char *fgetline(FILE *fp) {
    void *ss = new_ss();
    while (true) {
        int c = fgetc(fp);
        if (c == EOF && ss_size(ss) == 0) return NULL;
        if (c != EOF) ss_addc(ss, c);
        if (c == EOF || c == '\n') return ss_cstr(ss);
    }
    return NULL;
}

int fpeek(FILE *fp) {
    int c = fgetc(fp);
    if (c == EOF) return c;
    ungetc(c, fp);
    return c;
}
