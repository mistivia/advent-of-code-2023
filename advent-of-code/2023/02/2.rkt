#lang racket/base

(require "../../lib/utils.rkt")

(define fp (open-input-file "input"))

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

(define (power game)
  (define rs (map car game))
  (define gs (map cadr game))
  (define bs (map caddr game))
  (* (apply max rs) (apply max gs) (apply max bs)))

(apply + (map power (map extract-game lines)))
