Rebol [
    title: "Rosetta code: Möbius function"
    file:  %Möbius_function.r3
    url:   https://rosettacode.org/wiki/Möbius_function
]

mobius: function [
    {Returns a Möbius function vector of length limit
     MU[n] = 1 if n is square-free with even prime factors,
            -1 if n is square-free with odd prime factors,
             0 if n has a squared prime factor.}
    limit [integer!] "upper bound of the sieve"
][
    ;; --- sieve: build MU array up to limit ---
    MU: append/dup #(int32! []) 1 limit

    for i 0 square-root limit 1 [
        if i > 1 [
            if MU/:i == 1 [
                j: i
                while [j < limit] [
                    MU/:j: MU/:j * negate i
                    j: j + i
                ]
                j: i * i
                while [j < limit] [
                    MU/:j: 0
                    j: j + (i * i)
                ]
            ]
        ]
    ]
    ;; --- normalise: collapse ±multiples to ±1 ---
    i: 2
    while [i < limit] [
        v: MU/:i
        MU/:i: case [
            v =  i       [ 1]
            v = negate i [-1]
            v <  0       [ 1]
            v >  0       [-1]
            true         [ v]
        ]
        ++ i
    ]
    MU
]

mu: mobius 1000000

;; --- output first 199 terms ---
print "first 199 terms of the mobius sequence:"
prin "   "
repeat n 199 [
    prin pad form mu/:n -3
    if ((n + 1) % 20) = 0 [ print "" ]
]
print ""