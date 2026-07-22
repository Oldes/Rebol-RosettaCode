Rebol [
    title: "Rosetta code: Summarize primes"
    file:  %Summarize_primes.r3
    url:   https://rosettacode.org/wiki/Summarize_primes
]

print "index | prime | prime sum"
print "------------------------------"
s: i: 0
for n 2 999 1 [
    if prime? n [
        i: i + 1
        s: s + n
        if prime? s [
            printf [6 "| " 6 "| " 11] [i n s]
        ]
    ]
]
