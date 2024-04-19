#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp) (get-lines fp))))

(define (mat-copy mat)
  (list->vector (map string-copy (vector->list mat))))

(define (flip-mat mat)
  (list->vector (reverse (map string-copy (vector->list mat)))))

(define mat (list->vector lines))

(define (char-at mat x y)
  (string-ref (vector-ref mat y) x))

(define (set-mat! mat x y c)
  (string-set! (vector-ref mat y) x c))

(define (move-stone mat x1 y1 x2 y2)
  (define t (char-at mat x1 y1))
  (set-mat! mat x1 y1 (char-at mat x2 y2))
  (set-mat! mat x2 y2 t))

(define (find-new-pos mat x y)
  (let loop ((new-y y))
    (if (or (= new-y 0)
            (not (char=? #\. (char-at mat x (- new-y 1)))))
        new-y
        (loop (- new-y 1)))))

(define height (vector-length mat))
(define width (string-length (vector-ref mat 0)))

(define (tilt old-mat)
  (define mat (mat-copy old-mat))
  (do ((y 0 (+ y 1)))
      ((>= y height) (void))
    (do ((x 0 (+ x 1)))
        ((>= x width) (void))
      (when (char=? #\O (char-at mat x y))
        (move-stone mat x y x (find-new-pos mat x y)))))
  mat)

(define (count mat)
  (define sum 0)
  (do ((y 0 (+ y 1)))
      ((>= y height) (void))
    (do ((x 0 (+ x 1)))
        ((>= x width) (void))
      (when (char=? #\O (char-at mat x y))
        (set! sum (+ sum (- height y))))))
  sum)

(define (tilt-north mat)
  (tilt mat))

(define (tilt-south mat)
  (flip-mat (tilt (flip-mat mat))))

(define (transpose linesvec)
  (define lines (vector->list linesvec))
  (define width (string-length (vector-ref linesvec 0)))
  (define new-lines (make-vector width))
  (let loop ((i 0))
    (if (>= i width)
      new-lines
      (let ()
        (define char-list (map (λ (l) (string-ref l i)) lines))
        (vector-set! new-lines i (list->string char-list))
        (loop (+ i 1))))))

(define (tilt-west mat)
  (transpose (tilt (transpose mat))))

(define (tilt-east mat)
  (transpose (flip-mat (tilt (flip-mat (transpose mat))))))

(define mat-dict (make-hash))
(define r-mat-dict (make-hash))

(define (tilt-cycle mat)
  (tilt-east (tilt-south (tilt-west (tilt-north mat)))))

;; return (start . end)
(define (find-loop mat)
  (let loop ((i 1) (cur-mat mat))
    (define m (tilt-cycle cur-mat))
    (if (hash-has-key? mat-dict (vector->list m))
      (cons (hash-ref mat-dict (vector->list m)) i)
      (let ()
        (hash-set! mat-dict (vector->list m) i)
        (hash-set! r-mat-dict i (vector->list m))
        (loop (+ 1 i) m)))))

(define tmp (find-loop mat))
(define loop-start (car tmp))
(define loop-len (- (cdr tmp) (car tmp)))
(define reduced-num
  (+ loop-start (modulo (- 1000000000 loop-start) loop-len)))

(count (list->vector (hash-ref r-mat-dict reduced-num)))