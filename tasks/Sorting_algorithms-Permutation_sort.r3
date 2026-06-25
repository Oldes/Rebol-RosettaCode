Rebol [
    title: "Rosetta code: Sorting algorithms/Permutation sort"
    file:  %Sorting_algorithms-Permutation_sort.r3
    url:   https://rosettacode.org/wiki/Sorting_algorithms/Permutation_sort
]

sorted?: function [
    "Return true if block is in non-descending order"
    arr [block!]
][
    previous: first arr
    foreach item next arr [
        if item < previous [return false]
        previous: item
    ]
    true
]

permutation-sort: function [
    "Sort block by testing permutations one by one using Heap's algorithm"
    items [block!] "(modified)"
][
    n: length? items
    c: make vector! reduce ['uint32! n]                ;; zero-based control array
    if sorted? items [return items]
    i: 0
    while [i < n] [
        i+1: i + 1
        either c/:i+1 < i [
            either even? i [
                swap at items 1 at items i+1           ;; even size: swap with first
            ][  swap at items c/:i+1 + 1 at items i+1] ;; odd size: swap with c[i]
            if sorted? items [return items]            ;; check after each permutation
            c/:i+1: c/:i+1 + 1                         ;; advance cycle counter for level i
            i: 0                                       ;; restart from smallest prefix
        ][
            c/:i+1: 0                                  ;; reset counter
            ++ i                                       ;; move to next level
        ]
    ]
]

probe permutation-sort [3 1 2 8 5 7 9 4 6]