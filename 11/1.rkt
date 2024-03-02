#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(set! lines (list->vector lines))

(define (expand-rows lines)
  (let loop ((cur (vector->list lines)) (ret '()))
    (if (null? cur)
      (list->vector (reverse ret))
      (if (andmap (λ (c) (char=? c #\.)) (string->list (car cur)))
        (loop (cdr cur) (cons (car cur) (cons (car cur) ret)))
        (loop (cdr cur) (cons (car cur) ret))))))

(define (transpose linesvec)
  (define lines (vector->list linesvec))
  (define width (string-length (vector-ref linesvec 0)))
  (define new-lines (make-vector width))
  (let loop ((i 0))
    (if (>= i width)
      new-lines
      (let ()
        (define char-list (map (λ (l) (string-ref l i)) lines))
        (vector-set! new-lines i (list->string char-list))
        (loop (+ i 1))))))

(define universe
  (transpose (expand-rows (transpose (expand-rows lines)))))

(define height (vector-length universe))
(define width (string-length (vector-ref universe 0)))

(define (get-galaxies universe)
  (define (char-at x y) (string-ref (vector-ref universe y) x))
  (let loop ((x 0) (y 0) (ret '()))
    (if (>= y height)
      (list->vector (reverse ret))
      (if (>= x width)
        (loop 0 (+ y 1) ret)
        (if (char=? #\# (char-at x y))
          (loop (+ x 1) y (cons (cons x y) ret))
          (loop (+ x 1) y ret))))))

(define galaxies (get-galaxies universe))

(define (gen-pairs n)
  (let loop ((i 0) (j 1) (ret '()))
    (if (>= i n)
      (reverse ret)
      (if (>= j n)
        (loop (+ 1 i) (+ 2 i) ret)
        (loop i (+ 1 j) (cons (cons i j) ret))))))

(define (distance n1 n2)
  (define x1 (car (vector-ref galaxies n1)))
  (define x2 (car (vector-ref galaxies n2)))
  (define y1 (cdr (vector-ref galaxies n1)))
  (define y2 (cdr (vector-ref galaxies n2)))
  (+ (abs (- x1 x2)) (abs (- y1 y2))))

(apply
  +
  (map (λ (x) (distance (car x) (cdr x)))
       (gen-pairs (vector-length galaxies))))