#lang racket

(require "../../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (lambda (fp)
      (get-lines fp))))

(define elves (split-list-by "" lines))

(define (elf-sum elf)
  (apply + (map string->number elf)))

(define elf-sums (sort (map elf-sum elves) >))

(+ (car elf-sums) (cadr elf-sums) (caddr elf-sums))