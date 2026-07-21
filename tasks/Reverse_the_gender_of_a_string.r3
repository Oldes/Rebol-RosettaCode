Rebol [
    title: "Rosetta code: Reverse the gender of a string"
    file:  %Reverse_the_gender_of_a_string.r3
    url:   https://rosettacode.org/wiki/Reverse_the_gender_of_a_string
]

reverse-gender: function/with [
    "Swap gendered pronouns in a string (she/he, her/his, him/her, hers/his)."
    text [string!] "(modified)"
][
    parse text [
        any [
            opt [to sh]         ;; skip ahead to next S/H candidate
            s: [                ;; mark start of matched pronoun
                 "hers" | "she" | "her" | "he" | "his" | "him"
            ] e: [sp | end] (   ;; mark end; require word boundary
                part: copy/part s e
                e: change/part s select/case repls part e  ;; replace in-place
            ) :e                ;; resume after replacement (may differ in length)
            | skip              ;; no match — advance one char
        ]
    ]
    text
][
    ;; fast lookahead: all pronouns start with S or H
    sh: charset "SHsh"
    ;; punctuation/whitespace that may follow a pronoun
    sp: charset " ^-^M^/-.,:;!?'^"`[]{}()"
    ;; case-sensitive replacement map
    repls: #[
        "she" "he"      "he" "she"
        "She" "He"      "He" "She"
        "SHE" "HE"      "HE" "SHE"

        "her" "his"     "his" "her"
        "Her" "His"     "His" "Her"
        "HER" "HIS"     "HIS" "HER"

        "hers" "his"    "him" "her"
        "Hers" "His"    "Him" "Her"
        "HERS" "HIS"    "HIM" "HER"
    ]
]

foreach test [
    "She was a soul stripper. She took his heart!"
    "He was a soul stripper. He took her heart!"
    "She wants what's hers, he wants her and she wants him!"
    "Her dog belongs to him but his dog is hers!"
][
    print ""
    print as-yellow test
    print as-green reverse-gender test
]