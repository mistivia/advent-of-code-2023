#lang racket

(require "../../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (lambda (fp)
      (get-lines fp))))

(define instructions (string->list (car lines)))

(define (make-instruction-generator)
  (define cur instructions)
  (lambda ()
    (when (null? cur)
      (set! cur instructions))
    (define ret (car cur))
    (set! cur (cdr cur))
    ret))

(define next-instruction (make-instruction-generator))

(set! lines (cddr lines))

(define (parse-map str)
  (define p1 (string-split str "="))
  (define key (string-trim (car p1)))
  (define val-str (string-trim (cadr p1)))
  (define value (list (substring val-str 1 4) (substring val-str 6 9)))
  (cons key value))

(define the-map (make-hash (map parse-map lines)))

(define (is-start? str)
  (char=? #\A (string-ref str 2)))

(define (is-end? str)
  (char=? #\Z (string-ref str 2)))

(define (simulate start)
  (let loop ((i 0) (cur start))
    (if (is-end? cur)
      i
      (let ()
        (define instruction (next-instruction))
        (define (next-point point)
          (define mapping (hash-ref the-map point))
          (if (char=? instruction #\L)
            (car mapping)
            (cadr mapping)))
        (loop (+ 1 i) (next-point cur))))))


(define starts
  (let ()
    (define lst (hash->list the-map))
    (define keys (map car lst))
    (filter is-start? keys)))

(apply lcm (map simulate starts))