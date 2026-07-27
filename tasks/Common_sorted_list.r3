Rebol [
    title: "Rosetta code: Common sorted list"
    file:  %Common_sorted_list.r3
    url:   https://rosettacode.org/wiki/Common_sorted_list
]

common-sorted-list: function [
    "Return a sorted list of unique elements from list"
    list [block!]
][
    sort unique collect [forall list [keep list/1]]
]

probe common-sorted-list [[5 1 3 8 9 4 8 7]  [3 5 9 8 4]  [1 3 7 9]]