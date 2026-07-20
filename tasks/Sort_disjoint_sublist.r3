Rebol [
    title: "Rosetta code: Sort disjoint sublist"
    file:  %Sort_disjoint_sublist.r3
    url:   https://rosettacode.org/wiki/Sort_disjoint_sublist
]

sort-disjoint: function [
    "Sort only the values at the given indices, leaving all other positions untouched."
    data    [block!] "Source block (modified)"
    indices [block!] "One-based indices of positions to sort"
][
    inds: sort copy indices        ;; sorted index list (copy avoids mutating caller's block)
    vals: sort collect [           ;; extract & sort the values at those positions
        foreach i inds [keep data/:i]
    ]
    repeat j length? inds [
        poke data inds/:j vals/:j  ;; scatter sorted values back to their (sorted) slots
    ]
    data
]

probe sort-disjoint [7 6 5 4 3 2 1 0] [7 2 8]
