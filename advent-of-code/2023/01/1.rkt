#lang racket

(require "../../lib/utils.rkt")

(define fp (open-input-file "input"))

(define lines (get-lines fp))

(define (extract-number line)
  (define number-list (filter char-numeric? (string->list line)))
  (set! number-list (map (lambda (c)
                           (string->number (list->string (list c))))
                         number-list))
  (+ (last number-list) (* 10 (car number-list))))

(apply + (map extract-number lines))
