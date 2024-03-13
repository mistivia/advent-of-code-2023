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
  (do ((y 0 (+ y 1)))
      ((>= y height) (void))
    (do ((x 0 (+ x 1)))
        ((>= x width) (void))
      (when (char=? #\O (char-at x y))
        (move-stone x y x (find-new-pos x y))))))

(define (count)
  (define sum 0)
  (do ((y 0 (+ y 1)))
      ((>= y height) (void))
    (do ((x 0 (+ x 1)))
        ((>= x width) (void))
      (when (char=? #\O (char-at x y))
        (set! sum (+ sum (- height y))))))
  sum)

(tilt)
(count)