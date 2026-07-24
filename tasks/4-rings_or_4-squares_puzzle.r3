Rebol [
    title: "Rosetta code: 4-rings or 4-squares puzzle"
    file:  %4-rings_or_4-squares_puzzle.r3
    url:   https://rosettacode.org/wiki/4-rings_or_4-squares_puzzle
]

foursquares: function [
    "Count (and optionally print) solutions to the four-squares puzzle"
    lo [integer!] "Lower bound of the range"
    hi [integer!] "Upper bound of the range"
    /unique       "Require all seven values to be distinct"
    /show         "Print each solution as it's found"
][
    solutions: 0
    !unique: not unique
    for c lo hi 1 [
        for d lo hi 1 [
            if any [!unique  c <> d] [
                a: c + d  ;; first derived value
                if all [a >= lo  a <= hi] [
                    if any [!unique  all [c <> 0  d <> 0]] [
                        for e lo hi 1 [
                            if any [!unique  not find reduce [a c d] e] [
                                g: d + e  ;; second derived value
                                if all [g >= lo  g <= hi] [
                                    if any [!unique  not find reduce [a c d e] g] [
                                        for f lo hi 1 [
                                            if any [!unique  not find reduce [a c d g e] f] [
                                                b: e + f - c  ;; third derived value
                                                if all [b >= lo  b <= hi] [
                                                    if any [!unique  not find reduce [a c d g e f] b] [
                                                        solutions: solutions + 1
                                                        if show [
                                                            print [a b c d e f g]  ;; print the 7-tuple
                                                        ]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
    print [as-green solutions either unique ["unique"]["non-unique"] "solutions in" lo "to" hi LF]
    solutions
]

foursquares/unique/show 1 7
foursquares/unique/show 3 9
foursquares 0 9
