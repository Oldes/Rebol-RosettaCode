Rebol [
    title: "Rosetta code: Arithmetic derivative"
    file:  %Arithmetic_derivative.r3
    url:   https://rosettacode.org/wiki/Arithmetic_derivative
]

lagarias: function [
    "Recursively computes Lagarias' divisor-weighted factor-tree value for n"
    n [integer!]
][
    case [
        n < 0 [ return negate lagarias negate n ] ;; mirror negative n through the positive case
        any [n = 0 n = 1] [ return 0 ]            ;; base cases: 0 and 1 have value 0
    ]
    f: 2 while [not zero? n % f] [ ++ f ]  ;; find smallest factor f of n (f = n if n is prime)
    if 1 == q: n / f [ return 1 ]          ;; n was prime (q = 1) -> value is 1
    (q * lagarias f) + (f * lagarias q)    ;; combine recursively over the two factors
]

i: 1
for n -99 100 1 [
    prin pad lagarias n -5
    if zero? ++ i % 10 [prin LF]
]