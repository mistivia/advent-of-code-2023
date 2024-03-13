#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(define mat (list->vector lines))

(define (char-at x y)
  (string-ref (vector-ref mat y) x))

(define (set-mat! x y c)
  (string-set! (vector-ref mat y) x c))

(define (move-stone x1 y1 x2 y2)
  (define t (char-at x1 y1))
  (set-mat! x1 y1 (char-at x2 y2))
  (set-mat! x2 y2 t))

(define (find-new-pos x y)
  (let loop ((new-y y))
    (if (or (= new-y 0)
            (not (char=? #\. (char-at x (- new-y 1)))))
        new-y
        (loop (- new-y 1)))))

(define height (vector-length mat))
(define width (string-length (vector-ref mat 0)))

(define (tilt)
  (let loop ((y 0))
    (if (>= y height)
        (void)
        (let ()
          (let loop1 ((x 0))
            (if (>= x width)
                (void)
                (let ()
                  (define c (char-at x y))
                  (if (char=? #\O c)
                      (let ()
                        (define new-y (find-new-pos x y))
                        (move-stone x y x new-y)
                        (loop1 (+ 1 x)))
                      (loop1 (+ 1 x))))))
          (loop (+ 1 y))))))

(define (count)
  (let loop ((x 0) (y 0) (sum 0))
    (if (>= y height)
        sum
        (if (>= x width)
            (loop 0 (+ 1 y) sum)
            (let ()
              (define c (char-at x y))
              (if (char=? c #\O)
                  (loop (+ 1 x) y (+ sum (- height y)))
                  (loop (+ 1 x) y sum)))))))

(tilt)
(count)