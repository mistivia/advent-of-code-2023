#lang racket

(define line
  (call-with-input-file "input"
    (λ (fp) (read-line fp))))

(define strs (string-split line ","))

(define (parse-len str)
  (define str-len (string-length str))
  (define last-char (string-ref str (- str-len 1)))
  (if (char=? #\- last-char)
    (list (substring str 0 (- str-len 1)) #\-)
    (let ()
      (define tp (string-split str "="))
      (list (car tp) #\= (string->number (cadr tp))))))

(define (calc-hash str)
  (define len (string-length str))
  (let loop ((i 0) (cur 0))
    (if (< i len)
      (let ()
        (define c (string-ref str i))
        (define ascii (char->integer c))
        (loop (+ i 1) (modulo (* 17 (+ cur ascii)) 256)))
      cur)))

(define (remove-len lst lable)
  (let loop ((cur lst) (ret '()))
    (if (null? cur)
      (reverse ret)
      (if (equal? (caar cur) lable)
        (loop (cdr cur) ret)
        (loop (cdr cur) (cons (car cur) ret))))))

(define (insert-len lst lable value)
  (let loop ((cur lst) (ret '()) (inserted #f))
    (if (null? cur)
      (if inserted
        (reverse ret)
        (reverse (cons (cons lable value) ret)))
      (if (equal? (caar cur) lable)
        (loop (cdr cur) (cons (cons lable value) ret) #t)
        (loop (cdr cur) (cons (car cur) ret) inserted)))))

(define boxes (make-vector 256 '()))

(define lens (map parse-len strs))

(define (process-len len box)
  (if (char=? #\- (cadr len))
    (remove-len box (car len))
    (insert-len box (car len) (caddr len))))

;; do lens installation
(let loop ((cur lens))
  (if (null? cur)
    (void)
    (let ()
      (define lable (caar cur))
      (define hash-num (calc-hash lable))
      (vector-set! boxes hash-num (process-len (car cur) (vector-ref boxes hash-num)))
      (loop (cdr cur)))))

;; calculate focusing power
(let loop ((i 1) (ret 0))
  (if (> i 256)
    ret
    (let ()
      (define box (vector-ref boxes (- i 1)))
      (define sum
        (let loop ((j 1) (cur box) (s 0))
          (if (null? cur)
            s
            (loop (+ j 1) (cdr cur) (+ s (* i j (cdar cur)))))))
      (loop (+ i 1) (+ ret sum)))))
