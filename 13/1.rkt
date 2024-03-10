#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(define patterns (split-list-by "" lines))

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
      0
      (apply max (map count start))))

(define (score pattern)
  (+ (* 100 (find-reflection pattern))
     (find-reflection (transpose-list pattern))))

(apply + (map score patterns))
