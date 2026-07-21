Rebol [
    title: "Rosetta code: Sierpinski triangle/Graphical"
    file:  %Sierpinski_triangle-Graphical.r3
    url:   https://rosettacode.org/wiki/Sierpinski_triangle/Graphical
    needs: blend2d
]

sierpinski: function/with [
    "Generate draw-dialect commands for a Sierpinski triangle fractal."
    txy    [block!]   "Flat list of three triangle vertices: [x1 y1 x2 y2 x3 y3]"
    levels [integer!] "Recursion depth"
][
    append cmds: clear [] 'triangle
    sierpinski-run txy levels
    cmds
][
    cmds: []
    sierpinski-run: function [txy levels][
        either levels > 0 [
            ;; Midpoints between consecutive vertices
            m12x: txy/1 + txy/3 / 2.0   m12y: txy/2 + txy/4 / 2.0            ;; v1-v2
            m23x: txy/3 + txy/5 / 2.0   m23y: txy/4 + txy/6 / 2.0            ;; v2-v3
            m31x: txy/5 + txy/1 / 2.0   m31y: txy/6 + txy/2 / 2.0            ;; v3-v1
            levels: levels - 1
            sierpinski-run reduce [txy/1 txy/2  m12x m12y  m31x m31y] levels ;; top
            sierpinski-run reduce [m12x m12y  txy/3 txy/4  m23x m23y] levels ;; right
            sierpinski-run reduce [m31x m31y  m23x m23y  txy/5 txy/6] levels ;; bottom
        ][
            ;; Base case: emit a filled triangle
            repend cmds [
                as-pair txy/1 txy/2
                as-pair txy/3 txy/4
                as-pair txy/5 txy/6
            ]
        ]  
    ]
]

vertices: [400.0 20.0 724.0 580.0 76.0 580.0]
cmds: [fill-pen 255.0.0.50]
append cmds sierpinski vertices 2
append cmds [fill-pen 0.255.10.50]
append cmds sierpinski vertices 4
append cmds [fill-pen blue]
append cmds sierpinski vertices 8

browse save %Sierpinski_triangle-Graphical.png draw 800x600 cmds