#lang racket

(require "../lib/utils.rkt")

(define lines
  (call-with-input-file "input"
    (λ (fp)
      (get-lines fp))))

(define (unfold-pattern x)
  (append x (list #\?) x (list #\?) x (list #\?) x (list #\?) x))

(define (unfold-num x)
  (append x x x x x))

(define (parse-line line)
  (define line-splited (string-split line))
  (define arr-list (string->list (car line-splited)))
  (define conds (map string->number (string-split (cadr line-splited) ",")))
  (cons (reverse (cons #\. (reverse (unfold-pattern arr-list)))) (unfold-num conds)))

(define (cont-lava scanned)
  (define nums (filter (λ (n) (not (= 0 n)))
                       (map string-length (string-split scanned "."))))
  (if (null? nums)
      #f
      (car nums)))

(define (can-match? scanned remain)
  (if (null? scanned)
      'unknown
      (if (char=? #\# (car scanned))
          'unknown
          (let ()
            (define num (cont-lava (list->string scanned)))
            (if (not num)
                'unknown
                (if (null? remain)
                    'no
                    (if (= num (car remain))
                        'yes
                        'no)))))))

(define (check-terminal scanned remain)
  (define can-match (can-match? scanned remain))
  (if (and (eq? 'yes can-match)
           (null? (cdr remain)))
    1
    (if (eq? 'no can-match)
      0
      (if (null? remain)
        1
        0))))

(define (possible-arr-num instance)
  (define conds (cdr instance))
  (define (impl recur scanned unscanned remain)
    (define can-match (can-match? scanned remain))
    (define (gen-next-scanned c lst)
      (if (and (null? lst) (char=? c #\.))
        '()
        (cons c lst)))
    (if (null? unscanned)
        (check-terminal scanned remain)
        (if (eq? can-match 'no)
            0
            (let ()
              (define next-scanned
                (if (eq? 'yes can-match)
                    '()
                    scanned))
              (define next-remain
                (if (eq? 'yes can-match)
                    (cdr remain)
                    remain))
              (define head (car unscanned))
              (if (not (char=? head #\?))
                  (recur recur (gen-next-scanned head next-scanned) (cdr unscanned) next-remain)
                  (+ (recur recur (gen-next-scanned #\. next-scanned) (cdr unscanned) next-remain)
                     (recur recur (gen-next-scanned #\# next-scanned) (cdr unscanned) next-remain)))))))
  (define memo (make-hash))
  (define (memo-impl recur scanned unscanned remain)
    (if (null? scanned)
      (if (hash-has-key? memo (list unscanned remain))
        (hash-ref memo (list unscanned remain))
        (let ()
          (define ret (impl recur scanned unscanned remain))
          (hash-set! memo (list unscanned remain) ret)
          ret))
      (impl recur scanned unscanned remain)))
  (memo-impl memo-impl '() (car instance) conds))

(apply + (map possible-arr-num (map parse-line lines)))