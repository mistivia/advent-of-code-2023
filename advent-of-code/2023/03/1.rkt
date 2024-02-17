#lang racket

(require "../../lib/utils.rkt")
(require "../../lib/obj.rkt")

(define (read-input)
  (call-with-input-file "input"
    (lambda (fp) 
      (list->vector (get-lines fp)))))

(define schema (read-input))

(define (char-at line col)
  (string-ref (vector-ref schema line) col))

(define height (vector-length schema))
(define width (string-length (vector-ref schema 0)))

(define make-num (obj-maker 'line 'col 'value 'length))

(define (scan-nums)
  (define nums '())
  (let loop ((i 0))
    (if (>= i height)
      (void)
      (let ()
        (let loop ((j 0))
            (define curline (vector-ref schema i))
            (if (>= j width)
            (void)
            (let ()
                (define next 1)
                (define (find-next)
                  (if (or (>= (+ j next) 140)
                          (not (char-numeric? (char-at i (+ j next)))))
                    (void)
                    (let ()
                      (set! next (+ 1 next))
                      (find-next))))
                (if (char-numeric? (char-at i j))
                  (let ()
                    (find-next)
                    (define value (string->number (substring curline j (+ j next))))
                    (set! nums (cons (make-num i j value next) nums)))
                  (void))
                (loop (+ j next)))))
        (loop (+ 1 i)))))
  (reverse nums))
(define nums (scan-nums))

(define (is-symbol? c)
  (and (not (char-numeric? c))
       (not (char=? #\. c))))

(define (collect-adjacent num)
  (define left
    (if (= 0 (num 'col))
      '()
      (list (char-at (num 'line) (- (num 'col) 1)))))
  (define right
    (if (= width (+ (num 'col) (num 'length)))
      '()
      (list (char-at (num 'line) (+ (num 'col) (num 'length))))))
  (define up
    (if (= 0 (num 'line))
      '()
      (string->list
        (substring (vector-ref schema (- (num 'line) 1))
                   (max 0 (- (num 'col) 1))
                   (min width (+ (num 'col) (num 'length) 1))))))
  (define down
    (if (= (- height 1) (num 'line))
      '()
      (string->list
        (substring (vector-ref schema (+ (num 'line) 1))
                   (max 0 (- (num 'col) 1))
                   (min width (+ (num 'col) (num 'length) 1))))))
  (append left right up down))

(define (is-part-num? num)
  (findf is-symbol? (collect-adjacent num)))

(apply + (map (lambda (x) (x 'value))
              (filter is-part-num? nums)))