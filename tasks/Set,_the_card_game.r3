Rebol [
    title: "Rosetta code: Set, the card game"
    file:  %Set,_the_card_game.r3
    url:   https://rosettacode.org/wiki/Set,_the_card_game
]

set-puzzle: function/with [
    "Deal a random number of cards from a shuffled SET deck and print all valid sets."
][
    init
    ncards: 8 + random 5             ;; random card count in range 8-12
    print ["Take" ncards "cards:"]
    repeat i ncards [
        ind: random length? pack
        append cards take at pack ind ;; draw and remove a random card
    ]
    print-cards cards
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
                    print "Set:"
                    print-cards reduce [cards/:i cards/:j cards/:k]
                ]
            ]
        ]
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
]

set-puzzle