Rebol [
    title: "Rosetta code: Seven-sided dice from five-sided dice"
    file:  %Seven-sided_dice_from_five-sided_dice.r3
    url:   https://rosettacode.org/wiki/Seven-sided_dice_from_five-sided_dice
]

dice5:  does [random 5]
dice25: does [dice5 - 1 * 5 + dice5]
dice7a: does [
    ;; Modulo mapping (biased)
    (dice25 - 1) % 7 + 1
]
dice7b: does [
    ;; Rejection sampling: discard results above 21 to ensure uniform distribution.
    until [h: dice25  h <= 21]
    (h - 1) % 7 + 1                  ;; unbiased: 21 = 3*7, so all remainders equal
]

check-dist: function [
    "Print normalised bucket frequencies and flag if any deviate more than 1%."
    'fun [word!]          ;; quoted word so caller passes bare name, not result
    n    [integer!]
][
    print ["^/Checking function:" as-green fun]
    fun: get fun                          ;; resolve word to its function value
    dist: make vector! [uint32! 7]        ;; zero-initialised uint32 buckets
    repeat i n [
        roll: fun
        dist/:roll: dist/:roll + 1        ;; increment bucket for this roll
    ]
    probe query dist [minimum maximum]    ;; quick sanity check on spread
    bad: false
    foreach [i: count] dist [
        h: count / n * 7                  ;; normalise: 1.0 = perfectly uniform
        print ajoin [
            "Bucket " index? i " contains " count " elements."
            if 0.01 < abs(h - 1) [bad: true " Skewed."]  ;; flag >1% deviation
        ]
    ]
    print ["->" either bad [as-red "not uniform"][as-green "uniform"]]
]

n: 1'000'000
check-dist dice7a n
check-dist dice7b n