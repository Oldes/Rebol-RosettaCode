Rebol [
    title: "Rosetta code: Teacup rim text"
    file:  %Teacup_rim_text.r3
    url:   https://rosettacode.org/wiki/Teacup_rim_text
]

rotateable?: function [
    "Return all rotations of w if every rotation is also in wordset, else false"
    word    [string!]
    wordset [block!]  ;; dictionary words *after* word, so rotations already reported earlier are skipped
][
    if 3 > word/length [return false]  ;; too short to have interesting rotations
    rotated: copy word
    append out: clear [] word          ;; reset shared literal block, seed with original word
    loop word/length - 1 [
        append rotated take rotated    ;; rotate: move first char to the end
        unless find wordset rotated [return false]
        append out copy rotated
    ]
    out
]

wordset: read/lines %unixdict.txt
forall wordset [
    ;; only search forward, so each rotation family is printed once,
    ;; starting from its alphabetically first word
    if words: rotateable? wordset/1 next wordset [
        print ajoin/with words " -> "
    ]
]