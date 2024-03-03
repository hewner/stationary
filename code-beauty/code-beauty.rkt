#lang racket

(require racket/trace)

(define source '(define count-occurances
                  (lambda (val lst)
                    (cond [(null? lst) zero]
                          [(eqv? (car lst) val) (add1 (count-occurances val (cdr lst)))]
                          [else (count-occurances val (cdr lst))]))))

(define svg-tag
  (lambda (str size)
    (lambda vals
      (when (< (length vals) size)
        (error "not enough values"))
      (apply printf str vals))))

(define rect (svg-tag "<rect width=\"~a\" height=\"~a\" x=\"~a\" y=\"~a\" stroke=\"black\" fill=\"none\" />~n" 4))
(define svg-header (svg-tag "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" width=\"~a\" height=\"~a\">~n" 2))
(define svg-footer (svg-tag "</svg>~n" 0))
(define text (svg-tag "<text x=\"~a\" y=\"~a\" stroke=\"none\" font-size=\"x-large\" fill=\"green\">~a</text>~n" 3))

(define atom? (compose not list?))

(define flatten-parens
  (lambda (datum)
    (if (atom? datum) (list datum)
        (append (list '*lparen*)
                (apply append (map flatten-parens datum))
                (list '*rparen*)))))

(define transformer
  (lambda (sym proc)
    (letrec [(recur (lambda (datum)
                      (cond [(atom? datum) datum]
                            [(null? datum) datum]
                            [(eqv? (car datum) sym)
                             (apply proc (map recur (cdr datum)))]
                            [else (map recur datum)])))]
      recur)))

(define insert-between
  (lambda (value lst)
    (if (or (null? lst) (null? (cdr lst)))
        lst
        (cons (car lst) (cons value (insert-between value (cdr lst)))))))

(define cond-split
  (transformer 'cond (lambda pairlist
                        (cons 'cond (insert-between '*break* pairlist)))))
                    
                                   
(define syg-width 13)
(define syg-height 30)

(define output-code
  (lambda (datum x y)
    (unless  (null? datum)
      (case (car datum)
        [(*break*) (output-code (cdr datum) x (+ y syg-height))]
        [(*lparen*) (text x y "(")
                    (output-code (cdr datum) (+ syg-width syg-width x) y)]
        [(*rparen*) (text x y ")")
                    (output-code (cdr datum) (+ syg-width syg-width x) y)]
      
        [else (let ((str (symbol->string (car datum))))
                (text x y str)
                (output-code (cdr datum) (+ x (* syg-width (add1 (string-length str)))) y))]))))

(with-output-to-file
  "recursive.svg"
  #:exists 'replace
  (lambda ()
    (svg-header 5000 500)
    (rect 100 200 3 10)
    (output-code (flatten-parens (cond-split source))  7 20)
    (svg-footer)
    ))
