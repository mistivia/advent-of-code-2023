#lang racket

(provide get-lines
         enumerate
         repeat
         split-list-by)

(define (repeat n e)
  (let loop ((i 0) (ret '()))
    (if (>= i n)
        ret
        (loop (+ 1 i) (cons e ret)))))

(define (get-lines fp)
  (let loop ((lines '()))
    (define l (read-line fp))
    (if (eof-object? l)
        (reverse lines)
        (loop (cons l lines)))))

(define (enumerate lst)
  (let loop ((i 1) (ret '()) (remain lst))
    (if (null? remain)
        (reverse ret)
        (loop (+ 1 i) (cons (list (car remain) i) ret) (cdr remain)))))

(define (split-list-by e lst . eq)
  (define cmp (if (null? eq) equal? eq))
  (let loop ((ret '())
             (cur '())
             (lst lst))
    (if (null? lst)
        (reverse (cons (reverse cur) ret))
        (if (cmp e (car lst))
            (loop (cons (reverse cur) ret) '() (cdr lst))
            (loop ret (cons (car lst) cur) (cdr lst))))))
