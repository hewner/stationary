#lang racket

(define source '(define count-occurances
                  (lambda (val lst)
                    (cond [(null? lst) 0]
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

(with-output-to-file
  "recursive.svg"
  #:exists 'replace
  (lambda ()
    (svg-header 500 500)
    (rect 100 200 3 10)
    (text 7 20 "hello world")
    (svg-footer)
    ))
