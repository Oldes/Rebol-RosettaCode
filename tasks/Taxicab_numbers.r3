Rebol [
    title: "Rosetta code: Taxicab numbers"
    file:  %Taxicab_numbers.r3
    url:   https://rosettacode.org/wiki/Taxicab_numbers
]

e: 1200
sums: make map! 700'000             ;; sum-of-two-cubes -> block of [a b] pairs producing it
repeat a (e - 2) [
    a3: a * a * a
    for b a (e - 1) 1 [
        b3: b * b * b
        s3: a3 + b3
        either pairs: sums/:s3 [
            repend pairs [a b]      ;; another way to reach this sum
        ][  sums/:s3: reduce [a b]] ;; first way seen for this sum
    ]
]

i: 0
foreach s3 sort keys-of sums [
    ab: select sums s3
    if 4 > length? ab [continue]                        ;; skip sums reached only one way
    i: i + 1
    if all [4 == length? ab i > 25 i < 2000] [continue] ;; thin out the common two-way cases
    if i > 2006 [break]
    prin ajoin [pad i -5 ": " as-green pad s3 10]
    foreach [a b] ab [
        prin ajoin [" = " pad a -3 "³ + " pad b -4 "³"]
    ]
    print ""
]