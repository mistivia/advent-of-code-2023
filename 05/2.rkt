#lang racket

(define port (open-input-file "input"))

(define seed
  (let ()
    (define nums-str
      (string-trim
       (list-ref (string-split (read-line port) ":") 1)))
    (define (pairing l)
      (define (loop ret l)
        (if (null? l)
            ret
            (loop
             (cons (cons
                    (car l)
                    (+ (car l) (cadr l)))
                   ret)
             (cddr l))))
      (loop '() l))
    (reverse
     (pairing (map string->number (string-split nums-str " "))))))

(begin (read-line port) (void))

(define (read-line-convert-eof port)
  (define line (read-line port))
  (if (eof-object? line) "" line))

(define (read-map)
  (define (loop ret)
    (define line (string-trim (read-line-convert-eof port)))
    (if (= 0 (string-length line))
        (sort (reverse ret) (λ (x y) (< (cadr x) (cadr y))))
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

(define (range-map mlist r)
  ;; r :: Range :: (start . end)
  ;; mlist :: List of (Map :: (dest, src, len))
  (define (loop result mlist r)
    (define start (car r))
    (define end (cdr r))
    (if (null? mlist)
        (cons r result)
        (let ()
          (define cur-map (car mlist))
          (define map-target (car cur-map))
          (define map-start (cadr cur-map))
          (define map-end (+ map-start (caddr cur-map)))
          (define offset (- map-target map-start))
          (define (pair-offset p) (cons (+ offset (car p)) (+ offset (cdr p))))
          (cond ((<= end start)
                 result)
                ((>= start map-end)
                 (loop result (cdr mlist) r))
                ((>= start map-start)
                 (loop
                  (cons (pair-offset (cons start (min end map-end)))
                        result)
                  (cdr mlist)
                  (cons (min end map-end) end)))
                ((<= end map-start)
                 (cons r result))
                ((< start map-start)
                 (loop
                  (cons (cons start map-start) result)
                  mlist
                  (cons map-start end)))
                (else (error "unhandled cond in range-map"))))))
  (reverse (loop '() mlist r)))

(define (gen-range-mapper the-map)
  (define (mapper range-list)
    (apply append
           (map
            (λ (range)
              (range-map the-map range))
            range-list)))
  mapper)

(define mappers (map gen-range-mapper maps))

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

(display (apply min (map car (find-location seed))))
