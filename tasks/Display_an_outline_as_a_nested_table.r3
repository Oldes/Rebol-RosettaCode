Rebol [
    title: "Rosetta code: Display an outline as a nested table"
    file:  %Display_an_outline_as_a_nested_table.r3
    url:   https://rosettacode.org/wiki/Display_an_outline_as_a_nested_table
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

tree-to-wikitable: function/with [
    "Render a [name children] tree as a WikiTable with colspan"
    tree [block!] "Flat [name children] block from indent-to-tree"
    /html         "Emit HTML table instead of wiki markup"
][
    root-name: tree/1
    children:  tree/2

    max-depth:   subtree-depth children
    total-width: leaf-width children

    ;; one block per depth level, each holds [colspan style name] triples
    rows: array/initial max-depth []

    ;; assign a stable color per top-level child branch
    branch: 0
    foreach [name child] children [
        branch: branch + 1
        style: any [pick palette branch + 1  last palette]
        append rows/1 reduce [leaf-width child  style  name]
        either empty? child [
            ;; leaf at root level — pad all deeper rows with empty cells
            repeat r max-depth - 1 [
                append rows/(1 + r) [1 _ _]
            ]
        ][
            collect-rows child 2 max-depth rows style
        ]
    ]

    ;; -- emit ---------------------------------------------------------------
    out: copy ""

    either html [
        append out {<table border="1" style="text-align:center;">^/}
        ;; root spans all columns
        append out ajoin [
            {<tr><td colspan="} total-width
            {" style="background:} palette/1 {">}
            root-name {</td></tr>^/}
        ]
        repeat d max-depth [
            append out "<tr>"
            foreach [span style name] rows/:d [
                append out either name [
                    ajoin [
                        {^/<td style="background:} style {;"}
                        if span > 1 [ajoin [{ colspan="} span {"}]]
                        {>} name {</td>}
                    ]
                ][ "<td></td>" ]
            ]
            append out "</tr>^/"
        ]
        append out "</table>^/"
    ][
        append out {^{| class="wikitable" style="text-align: center;"^/}
        ;; root spans all columns
        append out ajoin [
            {|-^/| style="background: } palette/1
            {;" colspan=} total-width " | " root-name "^/"
        ]
        repeat d max-depth [
            append out "|-^/"
            foreach [span style name] rows/:d [
                append out either name [
                    ajoin [
                        {| style="background: } style {;" }
                        if span > 1 [ajoin ["colspan=" span " "]]
                        "| " name "^/"
                    ]
                ][ "|  | ^/" ]
            ]
        ]
        append out "|}^/"
    ]
    out
][
    ;; -- helpers and palette live in the function's own context --------------

    leaf-width: function [
        "Number of leaves under a node; a leaf counts as 1"
        children [block!]
    ][
        if empty? children [return 1]
        w: 0
        foreach [name child] children [w: w + leaf-width child]
        w
    ]

    subtree-depth: function [
        "Max depth of subtree; a leaf returns 0, its parent 1, etc."
        children [block!]
    ][
        if empty? children [return 0]
        d: 0
        foreach [name child] children [d: max d subtree-depth child]
        d + 1
    ]

    ;; pastel palette — index 1 = root, index 2+ cycle over branches
    palette: [
        "#ffffe6" "#ffebd2" "#f0fff0" "#e6ffff" "#ffe6ff" "#e6e6ff"
    ]

    collect-rows: function [
        "Walk tree depth-first, depositing [colspan style name] triples into rows"
        children  [block!]
        depth     [integer!]
        max-depth [integer!]
        rows      [block!]
        style     [string!]  "Inherited color from parent branch"
    ][
        foreach [name child] children [
            repend rows/:depth [leaf-width child  style  name]
            either empty? child [
                ;; leaf — pad every deeper row with a blank cell
                repeat r max-depth - depth [
                    append rows/(depth + r) [1 _ _]
                ]
            ][
                collect-rows child depth + 1 max-depth rows style
            ]
        ]
    ]
]

tree: indent-to-tree {Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.}

print tree-to-wikitable tree
print tree-to-wikitable/html tree