#lang racket

;; https://www.codewars.com/kata/515f51d438015969f7000013

(provide pyramid)

(define (pyramid n)
  (define (loop ret level cur)
    (define next (cons 1 cur))
    (if (= level n)
        (reverse ret)
        (loop (cons next ret) (+ level 1) next)))
  (loop '() 0 '()))

