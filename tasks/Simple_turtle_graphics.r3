Rebol [
    title: "Rosetta code: Simple turtle graphics"
    file:  %Simple_turtle_graphics.r3
    url:   https://rosettacode.org/wiki/Simple_turtle_graphics
    needs: blend2d
]

turtle: context [
    cmds: [] pen-color: white
    scale: 8.0   ;; 100 units → 800 pixels
    x: y: 50.0
    deg:  0.0
    down: false
    
    init: does [
        x: y: 50.0  deg: 0.0  down: false
        append clear cmds [
            fill-all 0.0.0 line-width 4 pen on
        ]
    ]
    penup:   does [ down: false repend cmds ['pen off] ]
    pendown: does [ down: true  repend cmds ['pen pen-color] ]
    forward: func [n /local nx ny] [
        nx: x + (n * cosine deg)
        ny: y - (n * sine   deg)
        repend cmds [
            'line scale * as-pair x  y 
                  scale * as-pair nx ny
        ]
        x: nx
        y: ny
    ]
    turn: func [a] [ deg: deg - a ]
    home: does [
        x: y: 50.0  deg: 0.0  down: false
        repend cmds ['pen off]
    ]
]

with turtle [
    draw-house: does [
        turn 180
        forward 45
        turn 180
        pendown
        ;; Square base
        forward 30
        turn 90
        forward 30
        turn 90
        forward 30
        turn 90
        forward 30
        ;; Roof (equilateral triangle top)
        turn 30
        forward 30
        turn 120
        forward 30
        home
    ]

    draw-bar: function [data [block!]] [
        turn 90
        forward 30
        turn -90
        pendown
        mx: first find-max data
        foreach v data [
            h: v / mx * 50
            w: 45.0 / length? data
            turn -90
            forward h
            turn 90
            forward w
            turn 90
            forward h
            turn -90
        ]
        turn 180
        forward 45
        home
    ]

    init
    draw-house
    penup
    draw-bar [50 33 200 130 50]
]

browse save %Simple_turtle_graphics.png draw 800x800 turtle/cmds