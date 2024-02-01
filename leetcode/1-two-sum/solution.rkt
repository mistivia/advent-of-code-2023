#lang racket

;; https://leetcode.com/problems/two-sum/description/

(define/contract (two-sum nums target)
  (-> (listof exact-integer?) exact-integer? (listof exact-integer?))
  (define h (make-hash))
  (define (loop nums index)
    (define n (car nums))
    (define diff (- target n))
    (if (hash-has-key? h diff)
        (list index (hash-ref h diff))
        (let ()
            (hash-set! h n index)
            (loop (cdr nums) (+ 1 index)))))
  (loop nums 0))
