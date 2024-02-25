#lang racket

(require "../lib/utils.rkt")

(define fp (open-input-file "input"))

(define lines (get-lines fp))

(define (replace-digit str)
  (set! str (string-replace str "one" "o1ne"))
  (set! str (string-replace str "two" "t2wo"))
  (set! str (string-replace str "three" "t3hree"))
  (set! str (string-replace str "four" "f4our"))
  (set! str (string-replace str "five" "f5ive"))
  (set! str (string-replace str "six" "s6ix"))
  (set! str (string-replace str "seven" "s7even"))
  (set! str (string-replace str "eight" "e8ight"))
  (set! str (string-replace str "nine" "n9ine"))
  str)

(define (extract-number rawline)
  (define line (replace-digit rawline))
  (define number-list (filter char-numeric? (string->list line)))
  (set! number-list (map (λ (c)
                           (string->number (list->string (list c))))
                         number-list))
  (+ (last number-list) (* 10 (car number-list))))

(display (apply + (map extract-number lines)))
(newline)
