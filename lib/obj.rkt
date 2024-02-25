#lang racket

(provide obj-maker
         obj-set
         obj-show)

(define (alist->obj alist)
  (λ key
    (if (null? key)
        alist
        (cadr (assoc (car key) alist)))))

(define (obj-maker . fields)
  (λ inits
    (define alist (map list fields inits))
    (alist->obj alist)))

(define (obj-set record key value)
  (define alist (record))
  (define new-alist
    (let loop ((new-list '()) (cur alist) (is-set #f))
      (if (null? cur)
          (if is-set
              new-list
              (cons (list key value) new-list))
          (let ()
            (if (eq? key (caar cur))
                (loop (cons (list key value) new-list) (cdr cur) #t)
                (loop (cons (car cur) new-list) (cdr cur) is-set))))))
  (alist->obj new-alist))

(define (obj-show x) (x))