Rebol [
    title: "Rosetta code: Remove vowels from a string"
    file:  %Remove_vowels_from_a_string.r3
    url:   https://rosettacode.org/wiki/Remove_vowels_from_a_string
]

remove-vowels: function/with [
    "Remove all vowels from a string."
    text [string!] "(modified)"
    /with vowels [bitset!] "custom vowel charset; defaults to aeiou"
][
    vowels: any [vowels default-vowels]
    parse/case text [any [to vowels remove some vowels]]
    text
][
    default-vowels: charset "aeiouAEIOU"
]

print remove-vowels {
    Rosetta Code is a programming chrestomathy site.
    The idea is to present solutions to the same
    task in as many different languages as possible,
    to demonstrate how languages are similar and
    different, and to aid a person with a grounding
    in one approach to a problem in learning another.
}
