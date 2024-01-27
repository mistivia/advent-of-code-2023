#ifndef MAP_H_
#define MAP_H_

#include "rb_tree.h"

typedef struct {
    rb_node_t node;
    void *key;
    void *value;
} node_entry_t;
typedef int (*cmp_t)(void** a, void** b);

void* new_map(cmp_t compare);
void map_set(void* self, void* key, void* value);
void* map_get(void* self, void* key);
void map_erase(void* self, void* key);

void* map_begin(void *self);
void* map_next(void *self, void *iter);
void* map_iter_key(void* iter);
void* map_iter_value(void* iter);

void* new_dict();
void dict_set(void* self, const char *key, void* value);
void* dict_get(void* self, const char* key);
void dict_erase(void* self, const char* key);

void* dict_begin(void *self);
void* dict_next(void *self, void *iter);
const char* dict_iter_key(void* iter);
void* dict_iter_value(void* iter);

#endif
