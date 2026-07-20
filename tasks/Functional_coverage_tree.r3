Rebol [
    title: "Rosetta code: Functional coverage tree"
    file:  %Functional_coverage_tree.r3
    url:   https://rosettacode.org/wiki/Functional_coverage_tree
]

indent-to-tree: function [
    "Converts indented text to a nested block tree"
    text [string!]
    /tab tab-size [integer!] "Indentation size (default: 4)"
][
    tab-size: any [tab-size 4]
    lines: split-lines text
    stack: reduce [result: copy []]
    depths: copy [0]
    prev: 0

    foreach line lines [
        indent: tab-size
        parse line [
            any [#" " (++ indent) | #"^-" (indent: indent + tab-size)]
            copy name: to end
        ]
        if empty? name [continue]
        level: indent // tab-size
        if any [
            not zero? indent % tab-size  ;; catches non-multiple indentation
            1 < (level - prev)           ;; catches skipped levels
        ][
            do make error! "Invalid indentation!"
        ]
        prev: level
        ;; pop stack to current level
        while [level < length? depths] [
            take/last depths
            take/last stack
        ]

        node: reduce [name copy []]
        append last stack node
        append/only stack node/2
        append depths level
    ]
    result
]

;; -- Object prototype for an FC-node --
fc-node!: context [
    name:     ""
    weight:   0
    coverage: 0.0
    children: []
    parent:   none
]

fcn-set-coverage: func [
    n     [object!]
    value [decimal!]
][
    if n/coverage <> value [
        n/coverage: value
        if n/parent [
            fcn-update-coverage n/parent
        ]
    ]
]

fcn-update-coverage: func [n [object!]][
    if empty? n/children [exit]
    v1: v2: 0.0
    foreach child n/children [
        v1: v1 + (child/weight * child/coverage)
        v2: v2 +  child/weight
    ]
    fcn-set-coverage n (v1 / v2)
]

fcn-show: func [n [object!] /indent level [integer!]][
    indent: 4 * level: any [level 0]
    printf reduce [
        indent (32 - indent) "| " 6 " | " 8.000001 " |"
    ][  SP n/name n/weight n/coverage]

    foreach child n/children [
        fcn-show/indent child level + 1
    ]
]

build-tree: function [
    data [block! string!]
    parent [none! object!]
][
    if string? data [data: indent-to-tree data]
    parent: any [parent make fc-node! []]
    foreach [line children] data [
        val: split line #"|"
        node: make fc-node! [
            name:     trim/tail val/1
            weight:   any [attempt [transcode/one val/2] 1  ]
            coverage: any [attempt [transcode/one val/3] 0.0]
            children: copy []
            parent:   none
        ]
        node/parent: parent
        append parent/children node
        build-tree children node
    ]
    fcn-update-coverage parent
    parent
]

root: build-tree {
cleaning                        |        |          |
    house1                      |40      |          |
        bedrooms                |        |0.25      |
        bathrooms               |        |          |
            bathroom1           |        |0.5       |
            bathroom2           |        |          |
            outside_lavatory    |        |1         |
        attic                   |        |0.75      |
        kitchen                 |        |0.1       |
        living_rooms            |        |          |
            lounge              |        |          |
            dining_room         |        |          |
            conservatory        |        |          |
            playroom            |        |1         |
        basement                |        |          |
        garage                  |        |          |
        garden                  |        |0.8       |
    house2                      |60      |          |
        upstairs                |        |          |
            bedrooms            |        |          |
                suite_1         |        |          |
                suite_2         |        |          |
                bedroom_3       |        |          |
                bedroom_4       |        |          |
            bathroom            |        |          |
            toilet              |        |          |
            attics              |        |0.6       |
        groundfloor             |        |          |
            kitchen             |        |          |
            living_rooms        |        |          |
                lounge          |        |          |
                dining_room     |        |          |
                conservatory    |        |          |
                playroom        |        |          |
            wet_room_&_toilet   |        |          |
            garage              |        |          |
            garden              |        |0.9       |
            hot_tub_suite       |        |1         |
        basement                |        |          |
            cellars             |        |1         |
            wine_cellar         |        |1         |
            cinema              |        |0.75      |} none

cleaning: root/children/1
top-coverage: cleaning/coverage

print ["TOP COVERAGE =" top-coverage newline]
print "NAME HIERARCHY                  | WEIGHT | COVERAGE |"
fcn-show cleaning

cinema: cleaning/children/2/children/3/children/3
fcn-set-coverage cinema 1.0
print rejoin [
    "^/If the coverage of the Cinema node were increased from 0.75 to 1^/"
    "the top level coverage would increase by "
    round/to cleaning/coverage - top-coverage 0.000001
    " to " round/to cleaning/coverage 0.000001
]
