#include "vec.h"

#include <string.h>
#include "stdlib.h"

struct vec {
    size_t length;
    size_t capacity;
    void** buf;
};

static void vec_enlarge(struct vec* self) {
    self->buf = realloc(self->buf, self->capacity * sizeof(void*) * 2);
    self->capacity = self->capacity * 2;
}

void *new_vec() {
    struct vec* vec = malloc(sizeof(struct vec));
    vec->length = 0;
    vec->capacity = 16;
    vec->buf = malloc(16 * sizeof(void*));
    return vec;
}

void vec_push_back(void *self_, void* obj) {
    struct vec *self = self_;
    if (self->length == self->capacity) vec_enlarge(self);
    self->buf[self->length] = obj;
    self->length++;
}

void* vec_get(void *self_, size_t n) {
    struct vec *self = self_;
    if (n < 0 || n >= self->length) return NULL;
    return self->buf[n];
}


void vec_erase(void *self_, size_t n) {
    struct vec *self = self_;
    if (self->length <= n) {
        return;
    }
    memmove(self->buf + n, self->buf + n + 1, (self->length - n - 1) * sizeof(void*));
    self->length--;
}

size_t vec_size(void *self_) {
    struct vec *self = self_;
    return self->length;
}

void vec_reserve(void *self_, size_t n) {
    struct vec *self = self_;
    if (n <= self->capacity) {
        return;
    }
    self->buf = malloc(sizeof(void*) * n);
    self->capacity = n;
}

void vec_insert(void *self_, size_t pos, void *obj) {
    struct vec *self = self_;
    if (self->length == self->capacity) {
        vec_enlarge(self);
    }
    if (pos > self->length || pos < 0) return;
    memmove(self->buf + pos + 1, self->buf + pos, sizeof(void*) * (self->length - pos));
    self->buf[pos] = obj;
    self->length++;
}

