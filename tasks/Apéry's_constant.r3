Rebol [
    title: "Rosetta code: Apéry's constant"
    file:  %Apéry's_constant.r3
    url:   https://rosettacode.org/wiki/Apéry's_constant
    needs: 3.22.0 ;; used // as integer-division
]

base: 10000000  ;; each limb holds 7 decimal digits

bn: function [
    "Parse a decimal digit string into a bignum: block of base-1e7 limbs, least-significant first"
    s [string!]
][
    r: copy []
    i: length? s
    while [i > 0] [
        j: max 1 (i - 6)                    ;; take up to 7 digits per limb, from the right
        append r (to integer! copy/part skip s (j - 1) (i - j + 1))
        i: j - 1
    ]
    r
]

zero-pad7: function ["Zero-pad an integer limb value to exactly 7 digits" n [integer!]] [
    s: form n
    insert/dup s #"0" (7 - length? s)
    s
]

bns: function [
    "Convert a bignum (base-1e7 limb block, least-significant first) to its full decimal string"
    b [block!]
][
    s: form last b                          ;; most-significant limb needs no zero-padding
    for i ((length? b) - 1) 1 -1 [
        append s zero-pad7 b/:i
    ]
    s
]

trim-bn: function ["Drop leading (most-significant) zero limbs, keeping at least one limb" r [block!]] [
    while [all [1 < length? r 0 == last r]] [take/last r]
    r
]

bnmul: function [
    "Multiply two bignums (base-1e7 limb blocks), returns a new bignum"
    a [block!] b [block!]
][
    if (length? a) > length? b [tmp: a a: b b: tmp]    ;; iterate outer over the shorter operand
    r: append/dup copy [] 0 (length? a) + length? b
    repeat ia length? a [
        h: 0
        repeat ib length? b [
            idx: ia + ib - 1
            h: h + r/:idx + (b/:ib * a/:ia)
            r/:idx: h % base
            h: h // base
        ]
        r/(ia + length? b): r/(ia + length? b) + h     ;; carry lands one slot past the last idx written
    ]
    trim-bn r
]

bnadd: function [
    "Add two bignums"
    a [block!] b [block!]
][
    if (length? b) > length? a [tmp: a a: b b: tmp]    ;; ensure a is the longer (or equal) operand
    r: append/dup copy [] 0 length? a
    h: 0
    lb: length? b
    repeat i length? a [
        v: either i <= lb [b/:i] [0]
        h: h + a/:i + v
        r/:i: h % base
        h: h // base
    ]
    if h > 0 [append r h]
    trim-bn r
]

bncmp: function [
    "Compare two bignums: 1 if a>b, -1 if a<b, 0 if equal"
    a [block!] b [block!]
][
    la: length? a
    case [
        la > length? b [return  1]
        la < length? b [return -1]
    ]
    for i la 1 -1 [
        case [
            a/:i > b/:i [return  1]
            a/:i < b/:i [return -1]
        ]
    ]
    0
]

bnsub: function [
    "Subtract bignums: a - b, assumes a >= b"
    a [block!] b [block!]
][
    r: append/dup copy [] 0 length? a
    borrow: 0
    lb: length? b
    repeat i length? a [
        v: either i <= lb [b/:i] [0]
        d: (a/:i) - v - borrow
        borrow: either d < 0 [
            r/:i: d + base  1
        ][  r/:i: d         0 ]
    ]
    trim-bn r
]

bndivmod: function [
    "Divide two bignums: returns reduce [quotient remainder] (each a bignum block)"
    a-in [block!] b-in [block!]
][
    if 0 > bncmp a-in b-in [return reduce [copy [0] copy a-in]]
    a: copy a-in                              ;; a and b are mutated below (normalization) — never touch the caller's blocks
    b: copy b-in
    lb: length? b
    d: base // (b/:lb + 1)                    ;; Knuth's normalization factor
    c: 0
    if d > 1 [
        repeat i lb [
            c: c + (b/:i * d)
            b/:i: c % base
            c: c // base
        ]
        c: 0
        repeat i length? a [
            c: c + (a/:i * d)
            a/:i: c % base
            c: c // base
        ]
    ]
    append a c                                ;; extra top limb, so the quotient loop always has one to read
    q: append/dup copy [] 0 lq: (length? a) - lb
    v1: b/:lb
    v2: either lb >= 2 [b/(lb - 1)] [0]
    for j lq 1 -1 [
        u0: a/(j + lb)
        u1: a/(j + lb - 1)
        u2: either (j + lb) >= 3 [a/(j + lb - 2)] [0]   ;; guarded so the index never drops to 0
        either u0 = v1 [
            qh: base - 1
            rh: u1 + v1
        ][
            h: (u0 * base) + u1
            qh: h // v1
            rh: h % v1
        ]
        while [all [rh < base (qh * v2) > ((base * rh) + u2)]] [  ;; refine the trial quotient digit
            qh: qh - 1
            rh: rh + v1
        ]
        k: 0
        repeat i lb [                          ;; multiply-and-subtract qh*b from this window of a
            p: (qh * b/:i) + k
            k: p // base
            t: (a/(j + i - 1)) - (p % base)
            if t < 0 [
                t: t + base
                k: k + 1
            ]
            a/(j + i - 1): t
        ]
        t: a/(j + lb) - k
        either t < 0 [                         ;; trial digit was one too high: add b back and correct
            qh: qh - 1
            k: 0
            repeat i lb [
                t: (a/(j + i - 1)) + (b/:i) + k
                a/(j + i - 1): t % base
                k: t // base
            ]
            a/(j + lb): t + k
        ][
            a/(j + lb): t
        ]
        q/:j: qh
    ]
    if d > 1 [                                 ;; undo normalization on the remainder
        k: 0
        for i lb 1 -1 [
            t: (k * base) + a/:i
            a/:i: t // d
            k: t % d
        ]
    ]
    clear at a (lb + 1)                        ;; keep only the remainder's lb limbs
    while [all [1 < length? q 0 == last q]] [take/last q]
    while [all [1 < length? a 0 == last a]] [take/last a]
    reduce [q a]
]

bnmod: function ["Remainder of a / n" a [block!] n [block!]] [second bndivmod a n]
bndiv: function ["Quotient of a / n"  a [block!] n [block!]] [first  bndivmod a n]

bnfac: function ["Bignum factorial of n" n [integer!]] [
    r: [1] for i 2 n 1 [r: bnmul r reduce [i]]
]

bnpow: function ["Bignum b raised to integer power n" b [block!] n [integer!]] [
    r: [1] repeat i n [r: bnmul r b]
]

frac-digits: function ["Extract the 100 digits after the leading integer digit of bns b" b [block!]] [
    copy/part next bns b 100
]

dec: [1] repeat i 110 [dec: bnmul dec [10]]    ;; dec = 10^110, fixed-point scaling factor

apery: function [
    "Print 1 + 100 fractional digits of the Apery sum_{k=1}^{terms} 1/k^3 approximation to zeta(3)"
    terms [integer!]
][
    s: [0]
    repeat k terms [
        k3: bnmul reduce [k * k] reduce [k]
        s:  bnadd s (bndiv dec k3)
    ]
    ajoin ["1." frac-digits s]
]

markov: function [
    "Print 1 + 100 fractional digits of a markov-type rational series approximation to zeta(3), terms terms"
    terms [integer!]
][
    fact: fact2: [1]
    sum: [0]
    repeat k terms [
        fact: bnmul fact reduce [k]
        num:  bnmul fact fact
        mult: (2 * k) * (2 * k - 1)
        fact2: bnmul fact2 reduce [mult]
        cube: k * k * k
        den: bnmul fact2 reduce [cube]
        num: bnmul num dec
        f:   bndiv num den
        sum: either odd? k [bnadd sum f] [bnsub sum f]
    ]
    sum: bndiv (bnmul sum [5]) [2]
    ajoin ["1." frac-digits sum]
]

wedeniwski: function [
    "Print 1 + 100 fractional digits of the Wedeniwski series approximation to zeta(3), terms terms (k = 0..terms-1)"
    terms [integer!]
][
    fact1: fact2: [1]
    sum:   [0]
    for k 0 terms - 1 1 [
        if k > 0 [
            fact1: bnmul fact1 reduce [k]
            fact2: bnmul fact2 reduce [(2 * k) * (2 * k - 1)]
        ]
        fact3: bnmul fact2 reduce [2 * k + 1]
        num: bnmul (bnmul fact1 fact2) fact3
        num: bnpow num 3
        p:   reduce [126392 * k + 412708]
        p:   bnadd (bnmul p reduce [k]) [531578]
        p:   bnadd (bnmul p reduce [k]) [336367]
        p:   bnadd (bnmul p reduce [k]) [104000]
        p:   bnadd (bnmul p reduce [k]) [12463]
        num: bnmul num p
        den: bnpow (bnfac (4 * k + 3)) 3
        den: bnmul den (bnfac (3 * k + 2))
        f:   bndiv (bnmul dec num) den
        sum: either zero? k % 2 [bnadd sum f] [bnsub sum f]
    ]
    sum: bndiv sum [24]
    ajoin ["1." frac-digits sum]
]

print "^/Actual value to 100 decimal places:"
print "1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581"

print "^/First 1000 terms of ζ(3) truncated to 100 decimal places (accurate to 6 decimal places):"
print apery 1000

print "^/First 158 terms of Markov / Apéry representation truncated to 100 decimal places:"
print markov 158

print "^/First 20 terms of Wedeniwski representation truncated to 100 decimal places:"
print wedeniwski 20
