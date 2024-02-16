#lang racket/base

(define port (open-input-file "input"))

(define seed 
  (let ()
    (define nums-str 
      (string-trim
          (list-ref (string-split (read-line port) ":") 1)))
    (map string->number (string-split nums-str " "))))

(begin (read-line port) (void))

(define (read-line-convert-eof port)
  (define line (read-line port))
  (if (eof-object? line) "" line))

(define (read-map)
  (define (loop ret)
    (define line (string-trim (read-line-convert-eof port)))
    (if (= 0 (string-length line))
      (reverse ret)
      (loop (cons (map string->number (string-split line " "))
                  ret))))
  (read-line port)
  (loop '()))

(define s2s (read-map))
(define s2f (read-map))
(define f2w (read-map))
(define w2l (read-map))
(define l2t (read-map))
(define t2h (read-map))
(define h2l (read-map))
(define maps (list s2s s2f f2w w2l l2t t2h h2l))

(define (gen-mapper the-map)
  (define (mapper x)
    (define (loop the-map)
      (if (null? the-map)
        x
        (let ()
          (define cur-map (car the-map))
          (define target (car cur-map))
          (define start (cadr cur-map))
          (define len (caddr cur-map))
          (if (and (>= x start)
                   (<= x (+ start len)))
            (+ target (- x start))
            (loop (cdr the-map))))))
    (loop the-map))
  mapper)

(define mappers (map gen-mapper maps))


(define (comp-func funcs)
  (define procs (reverse funcs))
  (define (comp-rec arg)
    (if (null? procs)
        arg
        (let ((proc (car procs))
              (rest (cdr procs)))
          (set! procs rest)
          (proc (comp-rec arg)))))
  comp-rec)

(define (find-location x)
  ((comp-func mappers) x))

(display (apply min (map find-location seed)))
