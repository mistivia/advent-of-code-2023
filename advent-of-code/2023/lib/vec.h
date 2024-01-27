#ifndef VEC_H_ 
#define VEC_H_ 

#include <stddef.h>

void *new_vec();
void vec_push_back(void *self, void* obj);
void* vec_get(void *self, size_t n);
size_t vec_length(void *self);
void vec_erase(void *self, size_t n);
size_t vec_size(void* self);
void vec_reserve(void* self, size_t n);
void vec_insert(void* self, size_t pos, void* obj);

#endif
