Rebol [
    title: "Rosetta code: Set puzzle"
    file:  %Set_puzzle.r3
    url:   https://rosettacode.org/wiki/Set_puzzle
]

set-puzzle: function/with [
    "Deal ncards from a shuffled SET deck and print nsets valid sets."
    ncards [integer!]
    nsets  [integer!]
][
    until [
        init
        loop ncards [
            ;; draw and remove a random card
            ind: random length? pack
            append cards take at pack ind
        ]
        sets: get-sets cards
        (length? sets) = (3 * nsets)    ;; retry until exactly nsets sets found
    ]
    print "Cards:"
    print-cards cards
    print "Sets:"
    forskip sets 3 [
        print-cards reduce [sets/1  sets/2  sets/3]
    ]
][
    attrs: [                            ;; attribute labels indexed [attr][value 1-3]
        [one     two     three   ]
        [solid   striped open    ]
        [red     green   purple  ]
        [diamond oval    squiggle]
    ]

    pack:  copy []                      ;; full deck of 81 cards (indices 0-80)
    cards: copy []                      ;; current deal

    ;; Reset pack to all 81 cards.
    init: does [ clear cards  clear pack  for i 0 80 1 [append pack i] ]

    ;; Decode card index into a block of 4 attribute values (each 1-3).
    card-attr?: func [card][
        collect [
            repeat i 4 [
                keep (card % 3) + 1     ;; extract base-3 digit, shift to 1-based
                card: card // 3
            ]
        ]
    ]

    ;; Print each card as a padded row of attribute labels.
    print-cards: function [cards][
        foreach card cards [
            attr: card-attr? card
            prin "  "
            repeat i 4 [
                prin pad attrs/:i/(attr/:i) 8
            ]
            print ""
        ]
        print ""
    ]

    ;; Return a flat block of all valid SET triples found in cards.
    get-sets: function [cards][
        set: clear []
        num: length? cards
        repeat i num [
            a: card-attr? cards/:i
            for j i + 1 num 1 [
                b: card-attr? cards/:j
                for k j + 1 num 1 [
                    c: card-attr? cards/:k
                    ok?: true
                    repeat at 4 [
                        s: a/:at + b/:at + c/:at
                        unless find [3 6 9] s [ok?: false]  ;; must be all-same or all-different
                    ]
                    if ok? [
                        repend set [cards/:i cards/:j cards/:k]
                    ]
                ]
            ]
        ]
        set
    ]
]

set-puzzle 9 4