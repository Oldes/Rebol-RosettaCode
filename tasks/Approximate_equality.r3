Rebol [
    title: "Rosetta code: Approximate equality"
    file:  %Approximate_equality.r3
    url:   https://rosettacode.org/wiki/Approximate_equality
]

almost-equal: func [
    "Approximate equality: true if a and b differ by no more than a relative tolerance"
    a [number!] b [number!] /precision p [decimal!] "Relative tolerance; default 1e-14"
][
    (abs a - b) <= (abs a * any [p 1e-14])
]

test: function [
    "Print a, b, and whether almost-equal considers them equal"
    a [number!] b [number!] /precision p
][
    printf [18 "~= " 18 "== "] [a b almost-equal/:precision a b p]
]

test 100000000000000.01 100000000000000.011
test 100.01 100.011
test (10000000000000.001 / 10000) 1000000000.0000001
test 0.001 0.0010000001
test 1.01e-22 0
test ((sqrt 2.0) * (sqrt 2.0)) 2.0
test ((negate sqrt 2.0) * (sqrt 2.0)) -2.0
test 3.14159265358979323846 3.14159265358979324

print "^/With custom precision 0.01:"
test/precision 100.01 100.011 0.01