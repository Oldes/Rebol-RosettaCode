Rebol [
    title: "Rosetta code: Combinations with repetitions"
    file:  %Combinations_with_repetitions.r3
    url:   https://rosettacode.org/wiki/Combinations_with_repetitions
]

combinations: function [
    "Generate all k-element combinations with repetitions."
    k [integer!] "Number of elements per combination."
    items [integer! block!] "Maximum value or source values to combine."
    /flat "Return a flat list instead of a block of combinations."
][
    n: either block? items [length? items][items]
    
    ;; Start with the lowest combination: [1 1 ...]
    blk: array/initial k 1
    blk: collect [
        forever [
            ;; Return current combination.
            either flat [
                keep blk
            ][  keep/only copy blk ]

            ;; Find the rightmost value that can be increased.
            i: k
            while [
                i > 0
                blk/:i = n
            ][
                -- i
            ]

            if i = 0 [break]

            ;; Increase this position and repeat it to the right.
            value: blk/:i + 1
            while [i <= k] [
                blk/:i: value
                ++ i
            ]
        ]
    ]
    if block? items [
        ;; Replace indexes with actual values from the source block.
        either flat [
            forall blk [
                change/only blk items/(blk/1)
            ]
        ][
            foreach c blk [
                forall c [
                    change/only c items/(c/1)
                ]
            ]
        ]
    ]
    blk
]

probe combinations 2 3
probe combinations 2 [iced jam plain]
probe new-line/skip combinations/flat 2 [iced jam plain] on 2
print [
    "^/Number of combinations for k=3, n=10:"
    as-green (length? combinations/flat 3 10) / 3
]