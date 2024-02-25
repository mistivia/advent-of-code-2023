#lang racket

(define input
  (with-input-from-file "input"
    (λ ()
      (let loop ((cards '()))
        (define line (read-line))
        (if (or (eof-object? line)
                (= 0 (string-length line)))
            (reverse cards)
            (let ()
              (define splited-line (string-split line))
              (define hand (car splited-line))
              (define bid (string->number (cadr splited-line)))
              (loop (cons (list hand bid) cards))))))))

(define (card-number char)
  (cond ((eq? char #\A) 12)
        ((eq? char #\K) 11)
        ((eq? char #\Q) 10)
        ((eq? char #\J) 0)
        ((eq? char #\T) 9)
        (else (- (string->number (make-string 1 char))
                 1))))

(define (joker-transform type)
  (define joker-num (vector-ref type 0))
  (vector-set! type 0 0)
  (vector-sort! type >)
  (vector-set! type 0 (+ joker-num (vector-ref type 0)))
  type)

(define (hand-type hand)
  (define vec (make-vector 13 0))
  (let loop ((i 0))
    (if (>= i 5)
        (vector->list (joker-transform vec))
        (let ()
          (define index (card-number (string-ref hand i)))
          (vector-set! vec index (+ 1 (vector-ref vec index)))
          (loop (+ i 1))))))

(define (hand-type<? type1 type2)
  (if (or (null? type1)
          (null? type2))
      #f
      (if (= (car type1) (car type2))
          (hand-type<? (cdr type1) (cdr type2))
          (< (car type1) (car type2)))))

(define (hand-type=? type1 type2)
  (if (null? type1)
      #t
      (if (= (car type1) (car type2))
          (hand-type=? (cdr type1) (cdr type2))
          #f)))

(define (raw-hand<? hand1 hand2)
  (define h1 (map card-number (string->list hand1)))
  (define h2 (map card-number (string->list hand2)))
  (hand-type<? h1 h2))

(define (hand<? hand1 hand2)
  (define type1 (hand-type hand1))
  (define type2 (hand-type hand2))
  (if (hand-type=? type1 type2)
      (raw-hand<? hand1 hand2)
      (hand-type<? type1 type2)))

(define sorted-cards
  (sort input (λ (a b)
                (hand<? (car a) (car b)))))

(define (calc-points card)
  (* (cadar card) (cadr card)))

(define (enumerate lst)
  (let loop ((i 1) (ret '()) (remain lst))
    (if (null? remain)
        (reverse ret)
        (loop (+ 1 i) (cons (list (car remain) i) ret) (cdr remain)))))

(define result
  (apply + (map calc-points (enumerate sorted-cards))))

(display result)
(newline)
