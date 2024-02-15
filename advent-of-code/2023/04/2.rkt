#lang racket

(require "../lib/obj.rkt")

(define (get-lines fp)
  (let loop ((lines '()))
    (define l (read-line fp))
    (if (eof-object? l)
      (reverse lines)
      (loop (cons l lines)))))

(define fp (open-input-file "input"))

(define lines (get-lines fp))

(define (strip-head s)
  (string-trim (cadr (string-split s ":"))))

(set! lines (map strip-head lines))

(define make-card (obj-maker 'win-nums 'nums))

(define (parse-card s)
  (define lst (string-split s "|"))
  (define win-nums (map string->number (string-split (car lst))))
  (define nums (map string->number (string-split (cadr lst))))
  (make-card win-nums nums))

(define cards (map parse-card lines))

(define card-count (make-vector (length cards) 1))

(define (win-count card)
    (length (filter (lambda (x) (member x (card 'win-nums))) (card 'nums))))

(define card-vec (list->vector cards))

(let loop ((i 0))
  (if (>= i (vector-length card-count))
    (void)
    (let ()
      (define win-cnt (win-count (vector-ref card-vec i)))
      (let loop ((j (+ i 1)))
        (if (or (>= j (vector-length card-count))
                (>= j (+ 1 i win-cnt)))
            (void)
            (let ()
              (vector-set! card-count j (+ (vector-ref card-count i)
                                           (vector-ref card-count j)))
              (loop (+ 1 j)))))
      (loop (+ 1 i)))))

(apply + (vector->list card-count))