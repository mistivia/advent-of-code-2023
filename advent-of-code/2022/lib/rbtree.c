/*	$OpenBSD: tree.h,v 1.30 2020/10/10 18:03:41 otto Exp $	*/
/*
 * Copyright 2002 Niels Provos <provos@citi.umich.edu>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "rbtree.h"

#define RED   1
#define BLACK 0

static struct rbnode *rbtree_minmax(struct rbtree *, int);
void* rbtree_min(struct rbtree *head) {
    return rbtree_minmax(head, -1);
}
void* rbtree_max(struct rbtree *head) {
    return rbtree_minmax(head, 1);
}

void* rbtree_left(void *node) {
    struct rbnode *elm = node;
    if (node == NULL) return NULL;
    return elm->entry.rbe_left;
}
void* rbtree_right(void *node) {
    struct rbnode *elm = node;
    if (node == NULL) return NULL;
    return elm->entry.rbe_right;
}
void* rbtree_parent(void *node) {
    struct rbnode *elm = node;
    if (node == NULL) return NULL;
    return elm->entry.rbe_parent;
}

static void augment(struct rbtree * head, struct rbnode *elm) {
    if (head->augment != NULL) head->augment(elm);
}

static void rbtree_insert_color(struct rbtree *head, struct rbnode *elm);
static void rbtree_remove_color(struct rbtree *head, struct rbnode *parent,
                                struct rbnode *elm);

static void rotate_left(struct rbtree *head, struct rbnode *elm) {
    struct rbnode *tmp = elm->entry.rbe_right;
    if ((elm->entry.rbe_right = tmp->entry.rbe_left)) {
        tmp->entry.rbe_left->entry.rbe_parent = elm;
    }
    augment(head, elm);
    if ((tmp->entry.rbe_parent = elm->entry.rbe_parent)) {
        if (elm == elm->entry.rbe_parent->entry.rbe_left)
          elm->entry.rbe_parent->entry.rbe_left = tmp;
        else
          elm->entry.rbe_parent->entry.rbe_right = tmp;
    } else {
        head->rbh_root = tmp;
    }
    tmp->entry.rbe_left = elm;
    elm->entry.rbe_parent = tmp;
    augment(head, tmp);
    if (tmp->entry.rbe_parent) {
        augment(head, tmp->entry.rbe_parent);
    }
}

static void rotate_right(struct rbtree *head, struct rbnode *elm) {
    struct rbnode *tmp = elm->entry.rbe_left;
    if ((elm->entry.rbe_left = tmp->entry.rbe_right)) {
        tmp->entry.rbe_right->entry.rbe_parent = elm;
    }
    augment(head, elm);
    if ((tmp->entry.rbe_parent = elm->entry.rbe_parent)) {
        if (elm == elm->entry.rbe_parent->entry.rbe_left)
          elm->entry.rbe_parent->entry.rbe_left = tmp;
        else
          elm->entry.rbe_parent->entry.rbe_right = tmp;
    } else {
        head->rbh_root = tmp;
    }
    tmp->entry.rbe_right = elm;
    elm->entry.rbe_parent = tmp;
    augment(head, tmp);
    if (tmp->entry.rbe_parent) {
        augment(head, tmp->entry.rbe_parent);
    }
}

static void rbtree_insert_color(struct rbtree *head, struct rbnode *elm) {
  struct rbnode *parent, *gparent, *tmp;
  while ((parent = elm->entry.rbe_parent) && parent->entry.rbe_color == 1) {
    gparent = parent->entry.rbe_parent;
    if (parent == gparent->entry.rbe_left) {
      tmp = gparent->entry.rbe_right;
      if (tmp && tmp->entry.rbe_color == 1) {
        tmp->entry.rbe_color = BLACK;
        parent->entry.rbe_color = BLACK;
        gparent->entry.rbe_color = RED;
        elm = gparent;
        continue;
      }
      if (parent->entry.rbe_right == elm) {
        rotate_left(head, parent);
        tmp = parent;
        parent = elm;
        elm = tmp;
      }
      parent->entry.rbe_color = BLACK;
      gparent->entry.rbe_color = RED;
      rotate_right(head, gparent);
    } else {
      tmp = gparent->entry.rbe_left;
      if (tmp && tmp->entry.rbe_color == 1) {
        tmp->entry.rbe_color = BLACK;
        parent->entry.rbe_color = BLACK;
        gparent->entry.rbe_color = RED;;
        elm = gparent;
        continue;
      }
      if (parent->entry.rbe_left == elm) {
        rotate_right(head, parent);
        tmp = parent;
        parent = elm;
        elm = tmp;
      }
      parent->entry.rbe_color = BLACK;
      gparent->entry.rbe_color = RED;
      rotate_left(head, gparent);
    }
  }
  head->rbh_root->entry.rbe_color = BLACK;
}

static void rbtree_remove_color(struct rbtree *head, struct rbnode *parent,
                            struct rbnode *elm) {
  struct rbnode *tmp;
  while ((elm == NULL || elm->entry.rbe_color == 0) &&
         elm != head->rbh_root) {
    if (parent->entry.rbe_left == elm) {
      tmp = parent->entry.rbe_right;
      if (tmp->entry.rbe_color == 1) {
        tmp->entry.rbe_color = BLACK;
        parent->entry.rbe_color = RED;
        rotate_left(head, parent);
        tmp = parent->entry.rbe_right;
      }
      if ((tmp->entry.rbe_left == NULL ||
           tmp->entry.rbe_left->entry.rbe_color == 0) &&
          (tmp->entry.rbe_right == NULL ||
           tmp->entry.rbe_right->entry.rbe_color == 0)) {
        tmp->entry.rbe_color = RED;
        elm = parent;
        parent = elm->entry.rbe_parent;
      } else {
        if (tmp->entry.rbe_right == NULL ||
            tmp->entry.rbe_right->entry.rbe_color == 0) {
          struct rbnode *oleft;
          if ((oleft = tmp->entry.rbe_left))
            oleft->entry.rbe_color = BLACK;
          tmp->entry.rbe_color = RED;
          rotate_right(head, tmp);
          tmp = parent->entry.rbe_right;
        }
        tmp->entry.rbe_color = parent->entry.rbe_color;
        parent->entry.rbe_color = BLACK;
        if (tmp->entry.rbe_right)
          tmp->entry.rbe_right->entry.rbe_color = BLACK;
        rotate_left(head, parent);
        elm = head->rbh_root;
        break;
      }
    } else {
      tmp = parent->entry.rbe_left;
      if (tmp->entry.rbe_color == 1) {
        tmp->entry.rbe_color = BLACK;
        parent->entry.rbe_color = RED;
        rotate_right(head, parent);
        tmp = parent->entry.rbe_left;
      }
      if ((tmp->entry.rbe_left == NULL ||
           tmp->entry.rbe_left->entry.rbe_color == 0) &&
          (tmp->entry.rbe_right == NULL ||
           tmp->entry.rbe_right->entry.rbe_color == 0)) {
        tmp->entry.rbe_color = RED;
        elm = parent;
        parent = elm->entry.rbe_parent;
      } else {
        if (tmp->entry.rbe_left == NULL ||
            tmp->entry.rbe_left->entry.rbe_color == 0) {
          struct rbnode *oright;
          if ((oright = tmp->entry.rbe_right))
            oright->entry.rbe_color = BLACK;
          tmp->entry.rbe_color = RED;
          rotate_left(head, tmp);
          tmp = parent->entry.rbe_left;
        }
        tmp->entry.rbe_color = parent->entry.rbe_color;
        parent->entry.rbe_color = BLACK;
        if (tmp->entry.rbe_left)
          tmp->entry.rbe_left->entry.rbe_color = BLACK;
        rotate_right(head, parent);
        elm = head->rbh_root;
        break;
      }
    }
  }
  if (elm)
    elm->entry.rbe_color = BLACK;
}

void rbtree_remove(struct rbtree *head, void* elmv) {
  struct rbnode *elm = elmv;
  struct rbnode *child, *parent;
  int color;
  if (elm->entry.rbe_left == NULL)
    child = elm->entry.rbe_right;
  else if (elm->entry.rbe_right == NULL)
    child = elm->entry.rbe_left;
  else {
    struct rbnode *old = elm, *left;
    elm = elm->entry.rbe_right;
    while ((left = elm->entry.rbe_left))
      elm = left;
    child = elm->entry.rbe_right;
    parent = elm->entry.rbe_parent;
    color = elm->entry.rbe_color;
    if (child)
      child->entry.rbe_parent = parent;
    if (parent) {
      if (parent->entry.rbe_left == elm)
        parent->entry.rbe_left = child;
      else
        parent->entry.rbe_right = child;
      augment(head, parent);
    } else
      head->rbh_root = child;
    if (elm->entry.rbe_parent == old)
      parent = elm;
    elm->entry = old->entry;
    if (old->entry.rbe_parent) {
      if ((old->entry.rbe_parent)->entry.rbe_left == old)
        (old->entry.rbe_parent)->entry.rbe_left = elm;
      else
        (old->entry.rbe_parent)->entry.rbe_right = elm;
      augment(head, old->entry.rbe_parent);
    } else
      head->rbh_root = elm;
    old->entry.rbe_left->entry.rbe_parent = elm;
    if (old->entry.rbe_right)
      old->entry.rbe_right->entry.rbe_parent = elm;
    if (parent) {
      left = parent;
      if (head->augment != NULL) {
          do {
              augment(head, left);
          } while ((left = left->entry.rbe_parent));
      }
    }
    goto color;
  }
  parent = elm->entry.rbe_parent;
  color = elm->entry.rbe_color;
  if (child)
    child->entry.rbe_parent = parent;
  if (parent) {
    if (parent->entry.rbe_left == elm)
      parent->entry.rbe_left = child;
    else
      parent->entry.rbe_right = child;
    struct rbnode* goback = parent;
    if (head->augment != NULL) {
        do {
            augment(head, goback);
        } while ((goback = goback->entry.rbe_parent));
    }
  } else
    head->rbh_root = child;
color:
  if (color == 0)
    rbtree_remove_color(head, parent, child);
}

void* rbtree_insert(struct rbtree *head, void *elmv) {
  struct rbnode *elm = elmv;
  struct rbnode *tmp;
  struct rbnode *parent = NULL;
  int comp = 0;
  tmp = head->rbh_root;
  while (tmp) {
    parent = tmp;
    comp = head->cmp((void*)elm->content, (void*)parent->content);
    if (comp < 0)
      tmp = tmp->entry.rbe_left;
    else if (comp > 0)
      tmp = tmp->entry.rbe_right;
    else
      return tmp;
  }
  elm->entry.rbe_parent = parent;
  elm->entry.rbe_left = elm->entry.rbe_right = NULL;
  elm->entry.rbe_color = RED;
  if (parent != NULL) {
    if (comp < 0)
      parent->entry.rbe_left = elm;
    else
      parent->entry.rbe_right = elm;
    struct rbnode* goback = parent;
    if (head->augment != NULL) {
        do {
            augment(head, goback);
        } while ((goback = goback->entry.rbe_parent));
    }
  } else
    head->rbh_root = elm;
  rbtree_insert_color(head, elm);
  return (NULL);
}

void* rbtree_find(struct rbtree *head, void *key) {
  struct rbnode *tmp = head->rbh_root;
  int comp;
  while (tmp) {
    comp = head->cmp(key, (void*)tmp->content);
    if (comp < 0)
      tmp = tmp->entry.rbe_left;
    else if (comp > 0)
      tmp = tmp->entry.rbe_right;
    else
      return tmp;
  }
  return (NULL);
}

void* rbtree_next(struct rbtree *head, void *elmv) {
  struct rbnode *elm = elmv;
  if (elm->entry.rbe_right) {
    elm = elm->entry.rbe_right;
    while (elm->entry.rbe_left)
      elm = elm->entry.rbe_left;
  } else {
    if (elm->entry.rbe_parent &&
        (elm == (elm->entry.rbe_parent)->entry.rbe_left))
      elm = elm->entry.rbe_parent;
    else {
      while (elm->entry.rbe_parent &&
             (elm == (elm->entry.rbe_parent)->entry.rbe_right))
        elm = elm->entry.rbe_parent;
      elm = elm->entry.rbe_parent;
    }
  }
  return elm;
}

static struct rbnode *rbtree_minmax(struct rbtree *head, int val) {
  struct rbnode *tmp = head->rbh_root;
  struct rbnode *parent = NULL;
  while (tmp) {
    parent = tmp;
    if (val < 0)
      tmp = tmp->entry.rbe_left;
    else
      tmp = tmp->entry.rbe_right;
  }
  return parent;
};

static void rbtree_free_impl(struct rbnode *node, void (*free_cb)(void*)) {
  if (node == NULL) return;
  if (free_cb != NULL) free_cb(node->content);
  rbtree_free_impl(node->entry.rbe_left, free_cb);
  rbtree_free_impl(node->entry.rbe_right, free_cb);
  free(node);
}

void rbtree_free(struct rbtree *head, void (*free_cb)(void*)) {
  rbtree_free_impl(head->rbh_root, free_cb);  
}
