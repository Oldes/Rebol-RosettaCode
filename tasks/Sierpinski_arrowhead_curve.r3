Rebol [
    title: "Rosetta code: Sierpinski arrowhead curve"
    file:  %Sierpinski_arrowhead_curve.r3
    url:   https://rosettacode.org/wiki/Sierpinski_arrowhead_curve
    needs: blend2d
]

sierpinski-arrowhead: function/with [
    "Draw the Sierpinski arrowhead curve into a window using the L-system turtle method."
    size  [pair!]    "canvas dimensions in pixels (width x height)"
    order [integer!] "recursion depth; 0 = single segment, higher = finer fractal"
][
    width:  size/x
    height: size/y

    theta: 0.0          ;; turtle heading in degrees
    cx:    0.0          ;; turtle position: start centred horizontally
    cy:    height       ;; at the bottom edge

    prev: as-pair cx height

    draw-cmds: clear []

    ;; parity of order determines initial heading so the curve fills the triangle correctly
    either zero? order & 1 [
        curve draw-cmds order width 60
    ][
        turn 60
        curve draw-cmds order width -60
    ]
    ;; emit the final segment after the recursion unwinds
    line draw-cmds cx
    draw-cmds
][
    ;; --- persistent (with-block) locals ---
    theta: cx: cy: draw-cmds: curr: prev: _

    ;; emit one line segment from `prev` to the current turtle position,
    ;; then advance the turtle by `length` in direction `theta`
    line: func [cmds length] [
        curr: as-pair cx cy
        append cmds reduce ['line prev curr]
        cx: cx + (length * cosine theta)
        cy: cy + (length * sine   theta)
        prev: curr
    ]

    turn: func [angle] [ theta: (theta + angle) % 360 ]

    ;; recursive L-system expansion:
    ;;   ord 0 — base case: draw one segment of `length`
    ;;   ord N — split into three half-length sub-curves with alternating turn signs,
    ;;            matching the arrowhead substitution rule A→B-A-B, B→A+B+A
    curve: func [cmds ord length angle] [
        either ord = 0 [
            line cmds length
        ][
            ord: ord - 1 length: length / 2
            curve cmds ord length negate angle
            turn angle
            curve cmds ord length angle
            turn angle
            curve cmds ord length negate angle
        ]
    ]
]

canvas: make image! [770x770 0.0.0]
foreach [order color][
    4 255.100.0
    6 100.255.0
    8 0.100.255
][
    cmds: compose [pen (color) line-width (10 - order)]
    append cmds sierpinski-arrowhead 770x700 order
    draw canvas cmds
]

browse save %Sierpinski_arrowhead_curve.png canvas