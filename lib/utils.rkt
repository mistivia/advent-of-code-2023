#lang racket

(provide get-lines
         enumerate
         repeat
         split-list-by
         transpose-list)

(define (repeat n e)
  (let loop ((i 0) (ret '()))
    (if (>= i n)
        ret
        (loop (+ 1 i) (cons e ret)))))

(define (trim-lines lines)
  (if (= 0 (string-length (car lines)))
      (trim-lines (cdr lines))
      lines))

(define (get-lines fp)
  (define lines
    (let loop ((lines '()))
      (define l (read-line fp))
      (if (eof-object? l)
          (reverse lines)
          (loop (cons l lines)))))
  (reverse (trim-lines (reverse (trim-lines lines)))))

(define (enumerate lst)
  (let loop ((i 1) (ret '()) (remain lst))
    (if (null? remain)
        (reverse ret)
        (loop (+ 1 i) (cons (list (car remain) i) ret) (cdr remain)))))

(define (split-list-by e lst . eq)
  (define cmp (if (null? eq) equal? eq))
  (let loop ((ret '())
             (cur '())
             (lst lst))
    (if (null? lst)
        (reverse (cons (reverse cur) ret))
        (if (cmp e (car lst))
            (loop (cons (reverse cur) ret) '() (cdr lst))
            (loop ret (cons (car lst) cur) (cdr lst))))))

(define (transpose-list lines)
  (define width (string-length (car lines)))
  (define new-lines (make-vector width))
  (let loop ((i 0))
    (if (>= i width)
      (vector->list new-lines)
      (let ()
        (define char-list (map (λ (l) (string-ref l i)) lines))
        (vector-set! new-lines i (list->string char-list))
        (loop (+ i 1))))))
