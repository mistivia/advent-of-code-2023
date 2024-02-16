#lang racket/base

(require "../lib/utils.rkt")
(require "../lib/obj.rkt")

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

(define (point card)
  (define wins (length (filter (lambda (x) (member x (card 'win-nums))) (card 'nums))))
  (if (= wins 0)
    0
    (expt 2 (- wins 1))))

(apply + (map point (map parse-card lines)))
