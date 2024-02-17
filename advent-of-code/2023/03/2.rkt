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

(define (collect-adjacent-positions num)
  (define (position-range line start end)
    (define delta (- end start))
    (map list (repeat delta line) (range start end)))
  (define left
    (if (= 0 (num 'col))
      '()
      (list (list (num 'line) (- (num 'col) 1)))))
  (define right
    (if (= width (+ (num 'col) (num 'length)))
      '()
      (list (list (num 'line) (+ (num 'col) (num 'length))))))
  (define up
    (if (= 0 (num 'line))
      '()
      (position-range (- (num 'line) 1)
                      (max 0 (- (num 'col) 1))
                      (min width (+ (num 'col) (num 'length) 1)))))
  (define down
    (if (= (- height 1) (num 'line))
      '()
      (position-range (+ (num 'line) 1)
                      (max 0 (- (num 'col) 1))
                      (min width (+ (num 'col) (num 'length) 1)))))
  (append left right up down))

(define asterisks (make-hash))

(define (mark-adj-asterisk num)
  (define adjs (collect-adjacent-positions num))
  (define (mark coord)
    (if (not (char=? #\* (char-at (car coord) (cadr coord))))
      (void)
      (let ()
        (when (not (hash-has-key? asterisks coord))
          (hash-set! asterisks coord '()))
        (hash-set! asterisks coord (cons (num 'value) (hash-ref asterisks coord))))))
  (for-each mark adjs))

(for-each mark-adj-asterisk nums)

(define aster-list (hash->list asterisks))

(define (is-gear? aster)
  (define nums-list (cdr aster))
  (= 2 (length nums-list)))

(define (power aster)
  (define nums-list (cdr aster))
  (* (car nums-list) (cadr nums-list)))

(apply + (map power (filter is-gear? aster-list)))
