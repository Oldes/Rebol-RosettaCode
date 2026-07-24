Rebol [
    title: "Rosetta code: Addition chains"
    file:  %Addition_chains.r3
    url:   https://rosettacode.org/wiki/Addition_chains
]

find-brauer: function/with [
    "Find minimal Brauer (addition) chains for num." {
     Returns [count best-chain], where:
       - count      = number of distinct minimal-length Brauer chains
       - best-chain = one example minimal chain (1..num) as a vector!.}
    num [integer!]
] [
    chain: make vector! reduce ['uint32! n: num]
    in-chain: make bitset! n
    best-len: n
    cnt: 0
    extend-chain 1 0
    reduce [cnt best]
][
    chain: in-chain: best: best-len: cnt: c: n: _

    extend-chain: func [x pos][
        if x * (2 ** (best-len - pos)) < n [ exit ]
        ++ pos
        chain/:pos: x
        in-chain/:x: true
        
        either in-chain/(n - x) [
            ;; found solution
            either pos = best-len [
                cnt: cnt + 1
            ][
                best: copy/part chain pos
                best-len: pos
                cnt: 1
            ]
        ][
            if pos < best-len [
                for i pos 1 -1 [
                    if n > c: x + chain/:i [
                        extend-chain c pos
                    ]
                ]
            ]
        ]
        in-chain/:x: false
    ]
]

foreach num [7 14 21 29 32 42 64 47 79 191 382 379][
    set [cnt: best:] find-brauer num
    print ["N ="  num]
    print ["Minimum length of chains: L(n) =" as-green length? best]
    print ["Number of minimum length Brauer chains:" as-green cnt]
    print ["E.g.:" as-blue mold/flat/only to block! best LF]
]
