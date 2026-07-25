Rebol [
    title: "Rosetta code: Combinations and permutations"
    file:  %Combinations_and_permutations.r3
    url:   https://rosettacode.org/wiki/Combinations_and_permutations
]

perm: function [
    "Falling factorial: x * (x-1) * ... * (x-y+1), i.e. x! / (x-y)!"
    x [integer!] y [integer!]
][
    ;; Computed in floating point so large intermediate products
    ;; lose precision rather than overflowing an integer!
    z: 1.0
    for i (x - y + 1) x 1 [z: z * i]
    try/with [to integer! z][z]
]

fact: function ["Factorial of x, in floating point" x [integer!]] [
    z: 1.0
    for i 2 x 1 [z: z * i]
]

comb: function ["Binomial coefficient C(x,y)" x [integer!] y [integer!]] [
    if (x - y) < y [y: x - y]
    c: (perm x y) / (fact y)
    try/with [to integer! c][c]
]

lstirling: function/with [
    "Natural log of n! via Stirling's series; recurses up to n >= 10 first for better accuracy there"
    n [integer!]
][
    if n < 10 [return (lstirling (n + 1)) - (log-e (n + 1))]
    (0.5 * log-e (2 * pi * n)) + (n * log-e ((n / e) + (1 / (12 * e * n))))
][  e: exp 1 ]

tolog: function [
    "Convert a natural-log value v into 'mantissa e exponent' scientific notation, e.g. '1.234e567'"
    v [number!]
][
    h: to integer! (v / (log-e 10))
    mantissa: exp (v - (h * (log-e 10)))
    ajoin [mantissa #"e" h]
]

permf: function [
    "Scientific-notation approximation of P(n,k) for large n, via Stirling's series"
    n [integer!] k [integer!]
][
    tolog ((lstirling n) - (lstirling (n - k)))
]

combf: function [
    "Scientific-notation approximation of C(n,k) for large n, via Stirling's series"
    n [integer!] k [integer!]
][
    tolog ((lstirling n) - (lstirling (n - k)) - (lstirling k))
]

print as-yellow "=> Exact results:"
for n 1 12 1 [
    p: n // 3
    print ajoin ["P(" n "," p ") = " as-green perm n p]
]

;; double has 53 bits for integer
for n 10 50 10 [
    p: n // 3
    print ajoin ["C(" n "," p ") = " as-green comb n p]
]

print ""
print as-yellow "=> Floating point approximations:"
foreach n [5 50 500 1000 5000 15000] [
    p: n // 3
    print ajoin ["P(" n "," p ") = " as-green permf n p]
]

for n 100 1000 100 [
    p: n // 3
    print ajoin ["C(" n "," p ") = " as-green combf n p]
]