Rebol [
    title: "Rosetta code: Sierpinski square curve"
    file:  %Sierpinski_square_curve.r3
    url:   https://rosettacode.org/wiki/Sierpinski_square_curve
    needs: blend2d
]

sierpinski-square-curve: function/with [
    "Return draw-dialect line commands for a Sierpiński square curve of the given order."
    canvas [pair!]    "Canvas size used to scale and center the curve"
    order  [integer!] "Recursion depth (3–5 recommended)"
][
    lstr: expand-lsystem axiom rule-x order

    set [minx: miny: maxx: maxy:] turtle-bounds lstr 0.0

    width:  maxx - minx
    height: maxy - miny

    margin: 20
    ;; Scale to fit the larger axis within the canvas
    step: min (canvas/x - (2 * margin)) / width
              (canvas/y - (2 * margin)) / height

    ;; Shift origin so the curve's bounding box starts at margin
    x0: margin - (minx * step)
    y0: margin - (miny * step)

    turtle-to-lines lstr x0 y0 step 0.0
][
    ;; L-system for the Sierpinski square curve (angle: 90°)
    ;; Axiom: F+XF+F+XF   Rule X: XF-F+F-XF+F+XF-F+F-X
    axiom:  "F+XF+F+XF"
    rule-x: "XF-F+F-XF+F+XF-F+F-X"

    ;; Expand an L-system string for the given number of iterations.
    expand-lsystem: function [axiom rule-x order][
        result: copy axiom
        loop order [
            replace/all result "X" rule-x
        ]
        result
    ]

    ;; Return [minx miny maxx maxy] bounding box of the turtle path.
    turtle-bounds: function [lstr angle][
        x: y: 0.0  a: angle
        minx: maxx: 0.0  miny: maxy: 0.0
        foreach ch lstr [
            switch ch [
                #"F" [
                    x: x + cosine a
                    y: y + sine a
                    case [
                        x < minx [minx: x]
                        x > maxx [maxx: x]
                        y < miny [miny: y]
                        y > maxy [maxy: y]
                    ]
                ]
                #"+" [ a: a + 90.0 ]   ;; turn left  (Y-down screen coords)
                #"-" [ a: a - 90.0 ]   ;; turn right
            ]
        ]
        reduce [minx miny maxx maxy]
    ]
    ;; Walk an L-system string and return draw-dialect line commands.
    turtle-to-lines: function [lstr x0 y0 step angle][
        x: x0  y: y0  a: angle
        ;; Consecutive pairs after 'line are joined as a polyline
        append cmds: clear [] 'line
        foreach ch lstr [
            switch ch [
                #"F" [
                    append cmds as-pair x y
                    x: x + (step * cosine a)
                    y: y + (step * sine a)
                    append cmds as-pair x y
                ]
                #"+" [ a: a + 90.0 ]
                #"-" [ a: a - 90.0 ]
            ]
        ]
        cmds
    ]
]

;; Draw orders 2..4 layered, thinner lines for higher (denser) orders
canvas: make image! [800x800 0.0.0]
cmds: []
foreach [order color][
    2 200.0.0
    3 0.200.0
    4 0.0.200
][
    repend cmds ['pen color 'line-width 6 - order]
    append cmds sierpinski-square-curve 800x800 order
]

browse save %Sierpinski_square_curve.png draw canvas cmds