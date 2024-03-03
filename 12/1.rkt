#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp)
      (get-lines fp))))

(define (parse-line line)
  (define line-splited (string-split line))
  (define arr-list (string->list (car line-splited)))
  (define conds (map string->number (string-split (cadr line-splited) ",")))
  (cons arr-list conds))

(define (arr-match? lst conds)
  (define str (list->string (reverse lst)))
  (equal? conds (filter (λ (n) (not (= 0 n))) (map string-length (string-split str ".")))))

(define (possible-arr-num instance)
  (define conds (cdr instance))
  (define (impl scanned unscanned)
    (if (null? unscanned)
      (if (arr-match? scanned conds) 1 0)
      (let ()
        (define head (car unscanned))
        (if (not (char=? head #\?))
          (impl (cons head scanned) (cdr unscanned))
          (+ (impl (cons #\. scanned) (cdr unscanned))
             (impl (cons #\# scanned) (cdr unscanned)))))))
  (impl '() (car instance)))

(apply + (map possible-arr-num (map parse-line lines)))