#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(define patterns (split-list-by "" lines))

(define (fix-smudge pattern x y)
  (define new-pattern (map string-copy pattern))
  (define pattern-vec (list->vector new-pattern))
  (define c (string-ref (vector-ref pattern-vec y) x))
  (case c
    ((#\#) (string-set! (vector-ref pattern-vec y) x #\.))
    ((#\.) (string-set! (vector-ref pattern-vec y) x #\#)))
  (vector->list pattern-vec))

(define (find-reflection lines)
  (define lines-vec (list->vector lines))
  (define len (vector-length lines-vec))
  (define (find-first)
    (let loop ((i 0) (ret '()))
      (if (>= i (- len 1))
          (reverse ret)
          (if (string=? (vector-ref lines-vec i)
                        (vector-ref lines-vec (+ i 1)))
              (loop (+ 1 i) (cons i ret))
              (loop (+ 1 i) ret)))))
  (define (count start)
    (let loop ((cnt 1) (i start))
      (if (or (< i 0)
              (>= (+ start cnt) len))
          (+ start 1)
          (if (string=? (vector-ref lines-vec i)
                        (vector-ref lines-vec (+ start cnt)))
              (loop (+ 1 cnt) (- i 1))
              0))))
  (define start (find-first))
  (if (null? start)
      '()
      (filter (λ (x) (not (= 0 x)))
              (map count start))))

(define (score pattern)
  (define h-score (map (λ (x) (* 100 x))(find-reflection pattern)))
  (define w-score (find-reflection (transpose-list pattern)))
  (filter (λ (x) (not (= 0 x)))
          (append h-score w-score)))

(define (fixed-score pattern)
  (define original-score (car (score pattern)))
  (define w (string-length (car pattern)))
  (define h (length pattern))
  (let loop ((x 0) (y 0))
    (if (>= y h)
        0
        (if (>= x w)
            (loop 0 (+ 1 y))
            (let ()
              (define s (score (fix-smudge pattern x y)))
              (define result (filter (λ (x) (not (= original-score x)))
                                     s))
              (if (null? result)
                  (loop (+ 1 x) y)
                  (car result)))))))

(apply + (map fixed-score patterns))
