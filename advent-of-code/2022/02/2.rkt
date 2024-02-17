#lang racket

(require "../../lib/utils.rkt")

(define lines
    (call-with-input-file "input"
        (lambda (fp) (get-lines fp))))

(define games (map string-split lines))

(define (transform-cheat mine oppo)
    (cond ((string=? "X" mine) (cond ((string=? "A" oppo) "Z")
                                     ((string=? "B" oppo) "X")
                                     ((string=? "C" oppo) "Y")))
          ((string=? "Y" mine) (cond ((string=? "A" oppo) "X")
                                     ((string=? "B" oppo) "Y")
                                     ((string=? "C" oppo) "Z")))
          ((string=? "Z" mine) (cond ((string=? "A" oppo) "Y")
                                     ((string=? "B" oppo) "Z")
                                     ((string=? "C" oppo) "X")))))

(set! games
    (map
        (lambda (x)
            (list (car x) (transform-cheat (cadr x) (car x))))
        games))

(define (score game)
    (define (base-score mine)
        (cond ((string=? "X" mine) 1)
              ((string=? "Y" mine) 2)
              ((string=? "Z" mine) 3)))
    (define (win-score mine oppo)
        (cond ((string=? "X" mine) (cond ((string=? "A" oppo) 3)
                                         ((string=? "B" oppo) 0)
                                         ((string=? "C" oppo) 6)))
              ((string=? "Y" mine) (cond ((string=? "A" oppo) 6)
                                         ((string=? "B" oppo) 3)
                                         ((string=? "C" oppo) 0)))
              ((string=? "Z" mine) (cond ((string=? "A" oppo) 0)
                                         ((string=? "B" oppo) 6)
                                         ((string=? "C" oppo) 3)))))
    (+ (base-score (cadr game)) (win-score (cadr game) (car game))))

(apply + (map score games))