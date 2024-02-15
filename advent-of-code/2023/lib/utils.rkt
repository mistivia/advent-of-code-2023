#lang racket

(provide get-lines
         enumerate)

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