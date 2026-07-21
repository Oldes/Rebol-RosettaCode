Rebol [
    title: "Rosetta code: Shift list elements to left by 3"
    file:  %Shift_list_elements_to_left_by_3.r3
    url:   https://rosettacode.org/wiki/Shift_list_elements_to_left_by_3
]

shif-list-to-left: function [
    "Rotate list left in place by num positions, returning the modified list."
    list [block!]
    num  [integer!]
][
    append list take/part list num  ;; move first num elements to the tail
]

probe list: [1 2 3 4 5 6 7 8 9]
probe shif-list-to-left list 3
