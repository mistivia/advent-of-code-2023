#include "map.h"
#include "rb_tree.h"

#include <string.h>

typedef int (*rb_cmp_t)(void*, void*);

void* new_map(cmp_t compare) {
    rb_tree_t *tree = malloc(sizeof(rb_tree_t));
    rb_cmp_t cmp = (rb_cmp_t)compare;
    *tree = (rb_tree_t){NULL, cmp, NULL};
    return tree;
}

void map_set(void* self, void* key, void* value) {
    node_entry_t *iter = rb_tree_find(self, &key);
    if (iter == NULL) {
        iter = malloc(sizeof(*iter));
        iter->key = key;
        iter->value = value;
        rb_tree_insert(self, iter);
    } else {
        iter->value = value;
    }
}

void* map_get(void* self, void* key) {
    node_entry_t *iter = rb_tree_find(self, &key);
    if (iter == NULL) return NULL;
    return iter->value;
}

void map_erase(void* self, void* key) {
    rb_tree_remove(self, key);
}

void* map_begin(void *self) {
    return rb_tree_min(self);
}

void* map_next(void *self, void *iter) {
    return rb_tree_next(self, iter);
}

void* map_iter_key(void* iter_) {
    node_entry_t *iter = iter_;
    return iter->key;
}

void* map_iter_value(void* iter_) {
    node_entry_t *iter = iter_;
    return iter->value;
}

static int dict_cmp(void **a, void** b) {
    return strcmp(*a, *b);
}
void* new_dict() {
    return new_map(dict_cmp);
}

void dict_set(void* self, const char *key, void* value) {
    map_set(self, (void*)key, value);
}

void* dict_get(void* self, const char* key) {
    return map_get(self, (void*)key);
}

void dict_erase(void* self, const char* key) {
    map_erase(self, (void*)key);
}

void* dict_begin(void *self) {
    return map_begin(self);
}

void* dict_next(void *self, void *iter) {
    return map_next(self, iter);
}

const char* dict_iter_key(void* iter) {
    return map_iter_key(iter);
}

void* dict_iter_value(void* iter) {
    return map_iter_value(iter);
}


