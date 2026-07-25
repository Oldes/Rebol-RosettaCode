Rebol [
    title: "Rosetta code: Combinations"
    file:  %Combinations.r3
    url:   https://rosettacode.org/wiki/Combinations
]

combinations: function [
    "Generate all n-element combinations from the range 1..m."
    n [integer!] "Number of elements per combination."
    m [integer!] "Maximum value in the range."
][
    ; Start with the highest combination: [n n-1 ... 1]
    blk: copy []
    for i n 1 -1 [
        append blk i
    ]

    collect [
        forever [
            ;; Return the current combination in ascending order.
            keep/only reverse copy blk

            ;; Find the first position that can still be incremented.
            i: 1
            while [blk/:i >= (m - (i - 1))] [
                ++ i
                if i > n [exit]
            ]

            ;; Increment that position.
            blk/:i: blk/:i + 1

            ;; Reset all lower positions to maintain descending order.
            while [i > 1] [
                blk/(i - 1): blk/:i + 1
                -- i
            ]
        ]
    ]
]

probe combinations 2 3
probe combinations 3 5