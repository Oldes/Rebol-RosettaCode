Rebol [
    title: "Rosetta code: Sort an outline at every level"
    file:  %Sort_an_outline_at_every_level.r3
    url:   https://rosettacode.org/wiki/Sort_an_outline_at_every_level
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

print-tree: function [
    "Prints a name-children block tree with optional sorting"
    tree      [ block! ] "Tree block in [name children ...] format"
    /indent i [integer!] "Current indentation level (default: 0)"
    /sorted          "Sort children alphabetically at each level"
    /reverse         "Reverse the sort order (requires /sorted)"
][
    i: any [i 0]
    if sorted [sort/skip/:reverse tree 2]
    foreach [name child] tree [
        printf reduce [i * 4][SP name]
        unless empty? child [
            print-tree/indent/:sorted/:reverse child i + 1
        ]
    ]
]

tree: indent-to-tree {
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon}

print as-yellow "^/Parsed tree:"
print-tree tree
print as-yellow "^/Sorted tree:"
print-tree/sorted tree
print as-yellow "^/Sorted tree reversed:"
print-tree/sorted/reverse tree

print "^/^/Using TAB indented input.^/"
tree: indent-to-tree {
zeta
^-beta
^-gamma
^-^-lambda
^-^-kappa
^-^-mu
^-delta
alpha
^-theta
^-iota
^-epsilon}

print as-yellow "^/Sorted tree:"
print-tree/sorted tree