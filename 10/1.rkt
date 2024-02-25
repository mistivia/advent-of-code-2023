#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp)
      (get-lines fp))))

(define diagram (list->vector lines))
(define height (vector-length diagram))
(define width (string-length (vector-ref diagram 0)))
(define (char-at x y)
  (string-ref (vector-ref diagram y) x))

(define (find-start)
  (let loop ((x 0) (y 0))
    (if (>= y height)
      #f
      (if (>= x width)
        (loop 0 (+ y 1))
        (if (char=? #\S (char-at x y))
          (cons x y)
          (loop (+ x 1) y))))))

(define start (find-start))

(define (valid-pos? pos)
  (define x (car pos))
  (define y (cdr pos))
  (and (and (>= x 0) (< x width))
       (and (>= y 0) (< y height))))

(define first-pos
  (let ()
    (define up (cons (car start) (- (cdr start) 1)))
    (define down (cons (car start) (+ (cdr start) 1)))
    (define left (cons (- (car start) 1) (cdr start)))
    (define right (cons (+ (car start) 1) (cdr start)))
      (cond ((and (valid-pos? up)
                  (member (char-at (car up) (cdr up)) (list #\| #\F #\7)))
            up)
            ((and (valid-pos? down)
                  (member (char-at (car down) (cdr down)) (list #\| #\L #\J )))
            down)
            ((and (valid-pos? left)
                  (member (char-at (car left) (cdr left)) (list #\- #\F #\L )))
            left)
            ((and (valid-pos? right)
                  (member (char-at (car right) (cdr right)) (list #\- #\7 #\J)))
            right))))

(define (next cur recent)
  (define up (cons (car cur) (- (cdr cur) 1)))
  (define down (cons (car cur) (+ (cdr cur) 1)))
  (define left (cons (- (car cur) 1) (cdr cur)))
  (define right (cons (+ (car cur) 1) (cdr cur)))
  (define c (char-at (car cur) (cdr cur)))
  (define possible-pos
    (cond ((char=? c #\|) (list up down))
          ((char=? c #\-) (list left right))
          ((char=? c #\F) (list right down))
          ((char=? c #\L) (list up right))
          ((char=? c #\7) (list left down))
          ((char=? c #\J) (list up left))))
  (let loop ((cur possible-pos))
    (if (not (equal? (car cur) recent))
      (car cur)
      (loop (cdr cur)))))

(define (simulate)
  (let loop ((i 0) (cur first-pos) (recent start))
    (if (equal? cur start)
      i
      (let ()
        (define next-loc (next cur recent))
        (loop (+ i 1) next-loc cur)))))

(define loop-length (simulate))

(if (= 0 (modulo loop-length 2))
  (/ loop-length 2)
  (+ 1 (quotient loop-length 2)))
