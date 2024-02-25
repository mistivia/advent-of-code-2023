#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp)
      (get-lines fp))))

(define (parse-data line)
  (map string->number (string-split line)))

(define data (map parse-data lines))

(define (diff lst)
  (let loop ((cur lst) (ret '()))
    (if (or (null? cur) (null? (cdr cur)))
      (reverse ret)
      (loop (cdr cur) (cons (- (cadr cur) (car cur)) ret)))))

(define (predict lst)
  (if (andmap (λ (x) (= x (car lst))) lst)
    (car lst)
    (- (car lst) (predict (diff lst)))))

(apply + (map predict data))
