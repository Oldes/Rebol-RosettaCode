Rebol [
    title: "Rosetta code: The Name Game"
    file:  %The_Name_Game.r3
    url:   https://rosettacode.org/wiki/The_Name_Game
]

verse: function [
    "Print one verse of The Name Game for a given name"
    x [string!]
][
    x1: first x                     ;; first letter
    y:  next x                      ;; rest of the name
    if find "AEIOU" x1 [
        y: ajoin [lowercase x1 y]   ;; keep vowel start, lowercased
    ]
    b: ajoin [#"b" y]
    f: ajoin [#"f" y]
    m: ajoin [#"m" y]
    case [
        x1 == #"B" [b: y]           ;; avoid doubled B-sound
        x1 == #"F" [f: y]           ;; avoid doubled F-sound
        x1 == #"M" [m: y]           ;; avoid doubled M-sound
    ]
    print ajoin [x ", " x ", bo-" b]
    print ajoin ["Banana-fana fo-" f]
    print ajoin ["Fee-fi-mo-" m]
    print ajoin [x "!" LF]
]

foreach n ["Gary" "Earl" "Billy" "Felix" "Mary"] [ verse n ]