Rebol [
    title: "Rosetta code: Concatenate two primes is also prime"
    file:  %Concatenate_two_primes_is_also_prime.r3
    url:   https://rosettacode.org/wiki/Concatenate_two_primes_is_also_prime
]

print as-yellow "Concatenated-pair primes from primes < 100:^/"
primes: collect [ for i 2 99 1 [ if prime? i [keep i]] ]
primes: sort unique collect [
    foreach p1 primes [
        foreach p2 primes [
            if prime? n: to integer! ajoin [p1 p2] [
                keep n
            ]
        ]
    ]
]
i: 1 foreach p primes [
    prin pad p 5
    if zero? ++ i % 16 [prin LF]
]

print ["^/Found" as-green length? primes "concatenated primes."]