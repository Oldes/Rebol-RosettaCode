Rebol [
    title: "Rosetta code: Topological sort"
    file:  %Topological_sort.r3
    url:   https://rosettacode.org/wiki/Topological_sort
]

toposort: function [
    "Topologically sort a dependency map, returning a block of blocks (one per level)"
    data [map!]
][
    data: copy/deep data ;; work on a copy so caller's map is untouched

    ;; discard self dependencies
    foreach [k v] data [ if pos: find v k [remove pos] ]

    ;; add any items only ever seen as a dependency, with no deps of their own
    all-deps: copy []
    foreach [k v] data [append all-deps v]
    foreach item unique all-deps [
        unless find data item [data/:item: copy []]         ;; leaf node, no deps
    ]

    result: copy [] ;; one sorted block per dependency level
    forever [
        ordered: copy []
        foreach [k v] data [if empty? v [append ordered k]] ;; nodes with no remaining deps
        if empty? ordered [break]                           ;; nothing left to peel off
        append/only result new-line/all sort ordered off    ;; record this level

        new-data: make map! []     ;; next round: drop resolved nodes, their deps satisfied
        foreach [k v] data [
            unless find ordered k [new-data/:k: exclude v ordered]
        ]
        data: new-data
    ]

    assert [empty? data "cyclic dependency exists amongst"] ;; leftover data means a cycle
    new-line/all result on
]

probe toposort #[
    des_system_lib: [std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee]
    dw01:           [ieee dw01 dware gtech]
    dw02:           [ieee dw02 dware]
    dw03:           [std synopsys dware dw03 dw02 dw01 ieee gtech]
    dw04:           [dw04 ieee dw01 dware gtech]
    dw05:           [dw05 ieee dware]
    dw06:           [dw06 ieee dware]
    dw07:           [ieee dware]
    dware:          [ieee dware]
    gtech:          [ieee gtech]
    ramlib:         [std ieee]
    std_cell_lib:   [ieee std_cell_lib]
    synopsys:       []
]