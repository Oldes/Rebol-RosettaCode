Rebol [
    title: "Rosetta code: Sierpinski curve"
    file:  %Sierpinski_curve.r3
    url:   https://rosettacode.org/wiki/Sierpinski_curve
    needs: blend2d
]

sierpinski-curve: function/with [
    "Generate draw-dialect line commands for a Sierpinski curve fractal."
    x0    [ number!] "Starting x position"
    y0    [ number!] "Starting y position"
    step  [ number!] "Base segment length (h)"
    level [integer!] "Recursion depth"
][
    x1: x0  y1: y0  h: step
    repend cmds: clear [] ['line as-pair x1 y1]
    drawN level  lineNE  ;; top-right corner
    drawE level  lineSE  ;; bottom-right corner
    drawS level  lineSW  ;; bottom-left corner
    drawW level  lineNW  ;; top-left corner
    cmds
][
    ;; --- persistent (with-block) locals ---
    x1: y1: h: cmds: _

    ;; Append a line segment from current pen position to (x,y)
    lineto: func [x y] [
        append cmds as-pair x y
        x1: x  y1: y
    ]

    ;; Cardinal and diagonal single-step moves
    lineN:  does [lineto x1 y1 - (2 * h)]
    lineS:  does [lineto x1 y1 + (2 * h)]
    lineE:  does [lineto x1 + (2 * h) y1]
    lineW:  does [lineto x1 - (2 * h) y1]
    lineNW: does [lineto x1 - h   y1 - h]
    lineNE: does [lineto x1 + h   y1 - h]
    lineSE: does [lineto x1 + h   y1 + h]
    lineSW: does [lineto x1 - h   y1 + h]

    ;; Each drawX recurses into sub-curves, with diagonal connectors between them
    drawN: func [i] [
        either i = 1 [
            lineNE  lineN  lineNW ;; base: /‾\
        ][
            i: i - 1
            drawN i  lineNE       ;; north sub-curve, then step NE
            drawE i  lineN        ;; east  sub-curve, then step N
            drawW i  lineNW       ;; west  sub-curve, then step NW
            drawN i               ;; north sub-curve again (closes arch)
        ]
    ]
    drawE: func [i] [
        either i = 1 [
            lineSE  lineE  lineNE ;; base: \|/  right side
        ][
            i: i - 1
            drawE i  lineSE
            drawS i  lineE
            drawN i  lineNE
            drawE i
        ]
    ]
    drawS: func [i] [
        either i = 1 [
            lineSW  lineS  lineSE ;; base: \_/
        ][
            i: i - 1
            drawS i  lineSW
            drawW i  lineS
            drawE i  lineSE
            drawS i
        ]
    ]
    drawW: func [i] [
        either i = 1 [
            lineNW  lineW  lineSW ;; base: \|/  left side
        ][
            i: i - 1
            drawW i  lineNW
            drawN i  lineW
            drawS i  lineSW
            drawW i
        ]
    ]
]

cmds: [pen red line-width 4]
append cmds sierpinski-curve 30.0 770.0 12.0 4
append cmds [pen blue line-width 2]
append cmds sierpinski-curve 20.0 780.0 3.0 6
browse save %Sierpinski_curve.png draw 800x800 cmds