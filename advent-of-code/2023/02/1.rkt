#lang racket

(define fp (open-input-file "input"))

(define (get-lines fp)
  (let loop ((lines '()))
    (define l (read-line fp))
    (if (eof-object? l)
      (reverse lines)
      (loop (cons l lines)))))

(define lines (get-lines fp))

(define (extract-game line)
  (define game-str (cadr (string-split line ":")))
  (define sets-str (string-split game-str ";"))
  (set! sets-str (map string-trim sets-str))
  (map extract-set sets-str))

(define (extract-set str)
  (define r 0)
  (define g 0)
  (define b 0)
  (define balls (string-split str ","))
  (set! balls
    (map (lambda (s)
           (define pair (map string-trim (string-split s " ")))
           (list (string->number (car pair)) (cadr pair)))
         balls))
  (let loop ((balls balls))
    (if (null? balls)
      '()
      (let ()
        (define ball (car balls))
        (define number (car ball))
        (define color (cadr ball))
        (cond ((string=? "red" color) (set! r number))
              ((string=? "green" color) (set! g number))
              ((string=? "blue" color) (set! b number)))
        (loop (cdr balls)))))
  (list r g b))

(define (possible? game)
  (if (null? game)
    #t
    (let ()
      (define head (car game))
      (if (or (> (car head) 12)    ; r
              (> (cadr head) 13)   ; g
              (> (caddr head) 14)) ; b
        #f
        (possible? (cdr game))))))

(define (enumerate lst)
  (let loop ((i 1) (ret '()) (remain lst))
    (if (null? remain)
      (reverse ret)
      (loop (+ 1 i) (cons (list (car remain) i) ret) (cdr remain)))))

(apply + (map cadr
              (filter (lambda (game)
                        (possible? (car game)))
                      (enumerate (map extract-game lines)))))
