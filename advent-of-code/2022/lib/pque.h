#ifndef PQUEUE_H_
#define PQUEUE_H_

typedef struct {
    void *buf;
    int elemsz;
    int cap;
    int size;
    int (*cmp)(void*, void*);
} PQue;

void pq_init(PQue *pq, int cap, int elemsz, int (*cmp)(void*, void*));
void pq_push(PQue *pq, void *elem);
void pq_pop(PQue *pq);
void* pq_top();

#endif

