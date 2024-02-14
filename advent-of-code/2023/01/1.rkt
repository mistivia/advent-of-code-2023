#lang racket

(define fp (open-input-file "input"))
(define sum 0)

(define (get-lines fp)
  (let loop ((lines '()))
    (define l (read-line fp))
    (if (eof-object? l)
      (reverse lines)
      (loop (cons l lines)))))

(define lines (get-lines fp))

(define (extract-number line)
  (define number-list (filter char-numeric? (string->list line)))
  (set! number-list (map (lambda (c)
                           (string->number (list->string (list c))))
                         number-list))
  (+ (last number-list) (* 10 (car number-list))))

(apply + (map extract-number lines))
