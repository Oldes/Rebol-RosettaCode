Rebol [
    title: "Rosetta code: Sierpinski pentagon"
    file:  %Sierpinski_pentagon.r3
    url:   https://rosettacode.org/wiki/Sierpinski_pentagon
    needs: blend2d
]

pentaflake: function/with [
    "Generate draw-dialect polygon commands for a pentaflake fractal."
    center [pair!]    "Center"
    rad    [number!]  "Circumradius of current pentagon"
    levels [integer!] "Recursion depth"
    /no-center        "Omit the central sub-pentagon at each level"
][
    clear cmds
    pentaflake-run/:no-center center/x center/y rad levels
    cmds
][
    cmds: []

    ;; Pentaflake (Sierpinski pentagon): 6 sub-pentagons per level
    ;; Scale factor r = 1/(1+phi) where phi = golden ratio
    phi: (1.0 + sqrt 5.0) / 2.0
    r:    1.0 / (1.0 + phi)

    ;; Vertices of a regular pentagon centered at (cx,cy) with circumradius rad,
    ;; starting from the top (angle = -pi/2), going clockwise.
    pentagon-points: function [cx cy rad] [
        step: 2.0 * pi / 5.0
        pts: clear []
        for i 0 4 1 [
            angle: i * step - (pi / 2.0)
            repend pts [cx + (rad * cos angle)
                        cy + (rad * sin angle)]
        ]
        pts
    ]

    pentaflake-run: function [cx cy rad levels /no-center] [
        either levels = 0 [
            ;; Base case: emit a filled pentagon
            pts: pentagon-points cx cy rad
            repend cmds ['polygon
                as-pair pts/1 pts/2
                as-pair pts/3 pts/4
                as-pair pts/5 pts/6
                as-pair pts/7 pts/8
                as-pair pts/9 pts/10
            ]
        ][
            sub-rad: rad * r
            ;; Distance from current center to each sub-pentagon center
            dist: rad * (1.0 - r)
            step: 2.0 * pi / 5.0
            ;; 5 corner sub-pentagons
            repeat i 5 [
                angle: (i - 1) * step - (pi / 2.0)
                pentaflake-run/:no-center cx + (dist * cos angle)
                    cy + (dist * sin angle)
                    sub-rad
                    levels - 1
            ]
            ;; 1 central sub-pentagon
            unless no-center [
                pentaflake-run/:no-center cx cy sub-rad levels - 1
            ]
        ]
    ]
]

canvas: 800x800
center: canvas / 2
margin: 20
rad:    center/y - margin

cmds: [line-width 2]
append cmds [pen 120.20.20]              ;; level 1 — deep crimson pen
append cmds pentaflake/no-center center rad 1
append cmds [pen off fill-pen 210.80.0]  ;; level 3 — burnt orange
append cmds pentaflake/no-center center rad 3
append cmds [fill-pen 240.200.0]         ;; level 5 — gold
append cmds pentaflake center rad 5

browse save %Sierpinski_pentagon.png draw 800x800 cmds