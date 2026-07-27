Rebol [
    title: "Rosetta code: Common list elements"
    file:  %Common_list_elements.r3
    url:   https://rosettacode.org/wiki/Common_list_elements
]

common-elements: function [
    "Return the intersection of all blocks in list"
    list [block!]
][
    a: first list
    foreach b next list [
        a: intersect a b
    ]
]

probe common-elements [[2 5 1 3 8 9 4 6] [3 5 6 2 9 8 4] [1 3 7 6 9]]
