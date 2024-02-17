#lang racket/base

(require "../../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (lambda (fp)
      (get-lines fp))))

(define elves (split-list-by "" lines))

(define (elf-sum elf)
  (apply + (map string->number elf)))

(apply max (map elf-sum elves))