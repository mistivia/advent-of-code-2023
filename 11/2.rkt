#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(set! lines (list->vector lines))

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

(define (get-rows-to-expand lines)
  (let loop ((i 0) (ret '()))
    (if (>= i (vector-length lines))
      (reverse (cons 9999999 ret))
      (let ()
        (define str (vector-ref lines i))
        (if (andmap (λ (c) (char=? #\. c))
                    (string->list str))
            (loop (+ 1 i) (cons i ret))
            (loop (+ 1 i) ret))))))

(define rows-to-expand (get-rows-to-expand lines))
(define columns-to-expand (get-rows-to-expand (transpose lines)))

(define height (vector-length lines))
(define width (string-length (vector-ref lines 0)))

(define expand-param 1000000)

(define (build-expand-map num rows-to-expand)
  (define map (make-vector num))
  (let loop ((i 0) (cur 0) (rows rows-to-expand))
    (if (>= i num)
      map
      (begin
        (vector-set! map i cur)
        (if (= i (car rows))
          (loop (+ 1 i) (+ expand-param cur) (cdr rows))
          (loop (+ 1 i) (+ 1 cur) rows))))))

(define row-expand-map (build-expand-map height rows-to-expand))
(define column-expand-map (build-expand-map width columns-to-expand))

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

(define galaxies (get-galaxies lines))

(define (gen-pairs n)
  (let loop ((i 0) (j 1) (ret '()))
    (if (>= i n)
      (reverse ret)
      (if (>= j n)
        (loop (+ 1 i) (+ 2 i) ret)
        (loop i (+ 1 j) (cons (cons i j) ret))))))

(define (distance n1 n2)
  (define x1 (vector-ref column-expand-map (car (vector-ref galaxies n1))))
  (define x2 (vector-ref column-expand-map (car (vector-ref galaxies n2))))
  (define y1 (vector-ref row-expand-map (cdr (vector-ref galaxies n1))))
  (define y2 (vector-ref row-expand-map (cdr (vector-ref galaxies n2))))
  (+ (abs (- x1 x2)) (abs (- y1 y2))))

(apply
  +
  (map (λ (x) (distance (car x) (cdr x)))
       (gen-pairs (vector-length galaxies))))