Rebol [
    title: "Rosetta code: Twin primes"
    file:  %Twin_primes.r3
    url:   https://rosettacode.org/wiki/Twin_primes
]

twin-primes: function [
    "Counts twin prime pairs (i, i+2) with i of form 6k-1 up to limit"
    limit [integer!]
][
    k: 1 i: count: 0
    while [i <= limit] [
        i: (6 * k) - 1 ;; candidate lower twin, always of form 6k-1
        j: i + 2       ;; candidate upper twin
        if all [prime? i  prime? j] [ ++ count ] ;; both prime -> twin pair found
        k: k + 1
    ]
    count + 1
]

limit: 10 while [limit <= 1000000] [
    print ["From 2 to" limit "there are" as-green twin-primes limit "twin primes."]
    limit: limit * 10
]
