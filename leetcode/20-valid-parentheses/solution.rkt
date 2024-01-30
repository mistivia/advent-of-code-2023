#lang racket

;; https://leetcode.com/problems/valid-parentheses/

(define (is-left-paren c)
    (or (eq? c #\u28)
        (eq? c #\[)
        (eq? c #\{)))

(define (right-paren c)
    (cond ((eq? c #\u28) #\u29)
          ((eq? c #\[) #\])
          ((eq? c #\{) #\})))

(define/contract (is-valid s)
  (-> string? boolean?)
  (define (loop s stack)
    (if (= 0 (string-length s))
        (null? stack)
        (let ()
            (define c (string-ref s 0))
            (define remain (substring s 1))
            (if (is-left-paren c)
                (loop remain (cons c stack))
                (if (null? stack)
                    #f
                    (let ()
                        (define stack-top (car stack))
                        (if (eq? c (right-paren stack-top))
                            (loop remain (cdr stack))
                            #f)))))))
  (loop s '()))

