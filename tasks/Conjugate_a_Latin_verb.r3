Rebol [
    title: "Rosetta code: Conjugate a Latin verb"
    file:  %Conjugate_a_Latin_verb.r3
    url:   https://rosettacode.org/wiki/Conjugate_a_Latin_verb
]

conjugate: function/with  [
    "Print the present indicative conjugation of a Latin conjugation verb"
    verb [string!]
][
    st: copy verb
    unless ends: select endings take/all skip tail st -3 [
       print [as-red verb "non prima coniugatio verbi!"]
       exit
    ]
    if empty? st [
        print [as-red verb "non satis diu conjugatus!"]
        exit
    ]
    print ["^/Praesens indicativi temporis of:" as-green verb]
    foreach en ends [
        print ajoin ["                                 " st en]
    ]
][
    endings: #[
        "are" ["o"  "as" "at" "amus" "atis" "ant" ]
        "ere" ["o"  "is" "it" "imus" "itis" "unt" ]
        "ēre" ["eo" "es" "et" "emus" "etis" "ent" ]
        "ire" ["io" "is" "it" "imus" "itis" "iunt"]
    ]
]

foreach verb ["amare" "venire" "monēre" "tegere" "are" "qwerty"][
    conjugate verb
]