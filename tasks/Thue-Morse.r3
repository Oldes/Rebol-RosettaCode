Rebol [
    title: "Rosetta code: Thue-Morse"
    file:  %Thue-Morse.r3
    url:   https://rosettacode.org/wiki/Thue-Morse
]

thue-morse: function [
    "Generate the first max-steps sequences of the Thue-Morse construction"
    max-steps [integer!]
][
    result: copy [ ]
    val:    copy [0]
    count: 0
    forever [
        append result ajoin val               ;; stringify current sequence
        count: count + 1
        if count = max-steps [return result]
        append val map-each v val [1 - v]     ;; append the bit-flipped copy
    ]
]

foreach bits thue-morse 6 [print bits]