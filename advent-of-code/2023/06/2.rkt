#lang racket/base

(define in (open-input-file "input"))

(define (read-num)
   (define line (read-line in))
   (string->number
       (apply
            string-append 
            (string-split
                (cadr (string-split (string-trim line) ":"))))))

(define time (read-num))
(define distance (read-num))

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

(display (solve time distance))
(newline)
