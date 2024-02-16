#lang racket/base

;; https://www.codewars.com/kata/55e6f5e58f7817808e00002e

(provide seven)

(define (seven m)
  (define (impl cur steps)
    (define x (quotient cur 10))
    (define y (modulo cur 10))
    (define next (- x (* 2 y)))
    (if (< cur 100)
        (cons cur steps)
        (impl next (+ 1 steps))))
  (impl m 0))
