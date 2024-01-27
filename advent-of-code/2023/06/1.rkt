#lang racket

(define in (open-input-file "input"))

(define (read-num-list)
   (define line (read-line in))
   (map
       string->number
       (string-split
           (cadr (string-split (string-trim line) ":")))))

(define times (read-num-list))
(define distances (read-num-list))

(define games (map cons times distances))

(define (calc time hold-time)
    (* hold-time (- time hold-time)))

(define (solve time distance)
    (define (loop counter hold-time)
        (if (> hold-time time)
            counter
            (if (> (calc time hold-time) distance)
                (loop (+ 1 counter) (+ 1 hold-time))
                (loop counter (+ 1 hold-time)))))
    (loop 0 0))

(display (apply * (map 
                     (lambda (x) (solve (car x) (cdr x)))
                     games)))
(newline)
