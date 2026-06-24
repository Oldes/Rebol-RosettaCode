Rebol [
    title: "Rosetta code: Long multiplication"
    file:  %Long_multiplication.r3
    url:   https://rosettacode.org/wiki/Long_multiplication
]

multiply-big: function [
    "Multiply two big integers represented as strings"
    sa [string!] sb [string!]
][
    len-a: length? sa
    len-b: length? sb
    sr: append/dup copy "" #"0" len-a + len-b
    i: len-a
    while [i > 0] [
        j: len-b
        while [j > 0] [
            a: sa/:i - 48
            b: sb/:j - 48
            p2: i + j
            p1: p2 - 1
            p: (a * b) + (sr/:p2 - 48)
            sr/:p2: #"0"   + (p % 10) ;; digit
            sr/:p1: sr/:p1 + (p / 10) ;; carry
            -- j
        ]
        -- i
    ]
    parse sr [remove some #"0"] ;; remove zeros from the head
    sr
]
print multiply-big "18446744073709551616" "18446744073709551616"
