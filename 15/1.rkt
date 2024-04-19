#lang racket

(define line
  (call-with-input-file "input"
    (λ (fp) (read-line fp))))

(define strs (string-split line ","))

(define (calc-hash str)
  (define len (string-length str))
  (let loop ((i 0) (cur 0))
    (if (< i len)
      (let ()
        (define c (string-ref str i))
        (define ascii (char->integer c))
        (loop (+ i 1) (modulo (* 17 (+ cur ascii)) 256)))
      cur)))

(apply + (map calc-hash strs))